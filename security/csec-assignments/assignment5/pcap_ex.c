#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <stdint.h>
#include <stddef.h>
#include <arpa/inet.h>
#include <net/ethernet.h>
#include <netinet/ip.h>
#include <netinet/ip6.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>
#include <pcap.h>
#include <pcap/pcap.h>

#define LOG_NAME "log.txt"

/*
 * Assignment 5 - libpcap traffic monitor.
 *
 * We decode packets by hand down to TCP/UDP (IPv4 and IPv6), print the
 * 5-tuple and length info, detect TCP retransmissions, and print flow/packet
 * statistics on exit. Per the brief we do NOT use pcap_compile/pcap_setfilter;
 * the -f filter is parsed and matched manually (see struct filter / pass_filter).
 */

/* ------------------------------------------------------------------ output */

static FILE *out;                 /* stdout for -r, log.txt for -i */

/* ------------------------------------------------------------- statistics */

static unsigned long long stat_total_pkts  = 0;   /* every packet, incl. skipped */
static unsigned long long stat_tcp_pkts     = 0;
static unsigned long long stat_udp_pkts     = 0;
static unsigned long long stat_tcp_bytes    = 0;   /* on-wire bytes of TCP packets */
static unsigned long long stat_udp_bytes    = 0;
static unsigned long long stat_total_flows  = 0;
static unsigned long long stat_tcp_flows    = 0;
static unsigned long long stat_udp_flows    = 0;

/* ------------------------------------------------------- flow hash table */

/* A flow is the 5-tuple {src ip, src port, dst ip, dst port, protocol}.
 * Addresses are kept raw (16 bytes; IPv4 lives in the first 4) so IPv4 and
 * IPv6 share the same table. */
struct flow {
	uint8_t  family;          /* AF_INET / AF_INET6 */
	uint8_t  proto;           /* IPPROTO_TCP / IPPROTO_UDP */
	uint8_t  src[16];
	uint8_t  dst[16];
	uint16_t sport;
	uint16_t dport;

	uint32_t next_seq;        /* TCP: next expected sequence number */
	int      seq_valid;       /* TCP: is next_seq meaningful yet? */

	struct flow *next;        /* chaining */
};

#define HASH_BITS 16
#define HASH_SIZE (1u << HASH_BITS)
static struct flow *flow_table[HASH_SIZE];

static unsigned int flow_hash(const struct flow *f)
{
	/* FNV-1a over the identifying fields */
	unsigned int h = 2166136261u;
	const uint8_t *p = (const uint8_t *)f;
	size_t n = offsetof(struct flow, next_seq); /* hash only the 5-tuple part */
	for (size_t i = 0; i < n; i++) {
		h ^= p[i];
		h *= 16777619u;
	}
	return h & (HASH_SIZE - 1);
}

/* Look the flow up; create (and count) it if new. */
static struct flow *flow_get(const struct flow *key)
{
	unsigned int b = flow_hash(key);
	struct flow *f;

	for (f = flow_table[b]; f; f = f->next) {
		if (f->family == key->family && f->proto == key->proto &&
		    f->sport == key->sport && f->dport == key->dport &&
		    memcmp(f->src, key->src, 16) == 0 &&
		    memcmp(f->dst, key->dst, 16) == 0)
			return f;
	}

	f = calloc(1, sizeof(*f));
	if (!f) { perror("calloc"); exit(1); }
	*f = *key;
	f->next_seq = 0;
	f->seq_valid = 0;
	f->next = flow_table[b];
	flow_table[b] = f;

	stat_total_flows++;
	if (key->proto == IPPROTO_TCP) stat_tcp_flows++;
	else if (key->proto == IPPROTO_UDP) stat_udp_flows++;
	return f;
}

static void flow_table_free(void)
{
	for (unsigned i = 0; i < HASH_SIZE; i++) {
		struct flow *f = flow_table[i];
		while (f) { struct flow *n = f->next; free(f); f = n; }
		flow_table[i] = NULL;
	}
}

/* --------------------------------------------------------- manual filter */

/* Minimal hand-rolled filter (no pcap_compile). Supports, AND-combined:
 *   tcp | udp
 *   [src|dst] port <n>
 *   [src|dst] host <ip>
 */
struct filter {
	int   use_proto; uint8_t proto;
	int   use_port;  uint16_t port;  int port_dir;   /* 0 any, 1 src, 2 dst */
	int   use_host;  uint8_t host[16]; int host_fam; int host_dir;
	int   active;
};

static int parse_filter(const char *expr, struct filter *fl)
{
	memset(fl, 0, sizeof(*fl));
	if (!expr || !*expr) return 0;
	fl->active = 1;

	char buf[256];
	strncpy(buf, expr, sizeof(buf) - 1);
	buf[sizeof(buf) - 1] = '\0';

	char *save = NULL;
	char *tok = strtok_r(buf, " \t", &save);
	while (tok) {
		int dir = 0;                                 /* src/dst qualifier */
		if (strcmp(tok, "src") == 0) { dir = 1; tok = strtok_r(NULL, " \t", &save); }
		else if (strcmp(tok, "dst") == 0) { dir = 2; tok = strtok_r(NULL, " \t", &save); }
		if (!tok) break;

		if (strcmp(tok, "tcp") == 0) {
			fl->use_proto = 1; fl->proto = IPPROTO_TCP;
		} else if (strcmp(tok, "udp") == 0) {
			fl->use_proto = 1; fl->proto = IPPROTO_UDP;
		} else if (strcmp(tok, "port") == 0) {
			tok = strtok_r(NULL, " \t", &save);
			if (!tok) return -1;
			fl->use_port = 1; fl->port = (uint16_t)atoi(tok); fl->port_dir = dir;
		} else if (strcmp(tok, "host") == 0) {
			tok = strtok_r(NULL, " \t", &save);
			if (!tok) return -1;
			if (inet_pton(AF_INET, tok, fl->host) == 1)       fl->host_fam = AF_INET;
			else if (inet_pton(AF_INET6, tok, fl->host) == 1) fl->host_fam = AF_INET6;
			else return -1;
			fl->use_host = 1; fl->host_dir = dir;
		} else {
			fprintf(stderr, "filter: unsupported token \"%s\"\n", tok);
			return -1;
		}
		tok = strtok_r(NULL, " \t", &save);
	}
	return 0;
}

/* Return 1 if the decoded packet passes the active filter (or none). */
static int pass_filter(const struct filter *fl, const struct flow *f,
                       int addr_len)
{
	if (!fl->active) return 1;

	if (fl->use_proto && f->proto != fl->proto) return 0;

	if (fl->use_port) {
		int ok = 0;
		if (fl->port_dir == 1) ok = (f->sport == fl->port);
		else if (fl->port_dir == 2) ok = (f->dport == fl->port);
		else ok = (f->sport == fl->port || f->dport == fl->port);
		if (!ok) return 0;
	}

	if (fl->use_host) {
		int s = (memcmp(f->src, fl->host, addr_len) == 0);
		int d = (memcmp(f->dst, fl->host, addr_len) == 0);
		int ok = (fl->host_dir == 1) ? s : (fl->host_dir == 2) ? d : (s || d);
		if (!ok) return 0;
	}
	return 1;
}

/* ------------------------------------------------------------ decoding */

static int link_hdr_len = 14;     /* Ethernet; set from datalink in main */

static const char *proto_name(uint8_t p)
{
	switch (p) {
	case IPPROTO_TCP: return "TCP";
	case IPPROTO_UDP: return "UDP";
	default:          return "OTHER";
	}
}

/* pretty-print a raw address of the given family */
static void addr_str(int fam, const uint8_t *a, char *dst, size_t n)
{
	inet_ntop(fam, a, dst, n);
}

/* pcap callback */
static void on_packet(u_char *user, const struct pcap_pkthdr *h,
                      const u_char *bytes)
{
	const struct filter *fl = (const struct filter *)user;

	stat_total_pkts++;

	if (h->caplen < (bpf_u_int32)link_hdr_len)
		return;

	/* ---- L2: Ethernet ---- */
	uint16_t ethertype = ntohs(*(const uint16_t *)(bytes + 12));
	const u_char *l3 = bytes + link_hdr_len;
	unsigned int l3_avail = h->caplen - link_hdr_len;

	struct flow key;
	memset(&key, 0, sizeof(key));

	uint8_t  proto;
	const u_char *l4;
	unsigned int l4_avail;
	unsigned int ip_hdr_len;
	int addr_len;

	if (ethertype == ETHERTYPE_IP) {
		if (l3_avail < sizeof(struct ip)) return;
		const struct ip *ip4 = (const struct ip *)l3;
		ip_hdr_len = ip4->ip_hl * 4;
		if (ip_hdr_len < sizeof(struct ip) || l3_avail < ip_hdr_len) return;

		key.family = AF_INET;
		addr_len = 4;
		memcpy(key.src, &ip4->ip_src, 4);
		memcpy(key.dst, &ip4->ip_dst, 4);
		proto = ip4->ip_p;
		l4 = l3 + ip_hdr_len;
		l4_avail = l3_avail - ip_hdr_len;

	} else if (ethertype == ETHERTYPE_IPV6) {
		if (l3_avail < sizeof(struct ip6_hdr)) return;
		const struct ip6_hdr *ip6 = (const struct ip6_hdr *)l3;
		ip_hdr_len = sizeof(struct ip6_hdr);

		key.family = AF_INET6;
		addr_len = 16;
		memcpy(key.src, &ip6->ip6_src, 16);
		memcpy(key.dst, &ip6->ip6_dst, 16);
		/* Note: we read the first next-header only; packets whose transport
		 * header sits behind IPv6 extension headers are treated as OTHER. */
		proto = ip6->ip6_nxt;
		l4 = l3 + ip_hdr_len;
		l4_avail = l3_avail - ip_hdr_len;

	} else {
		return; /* not IP -> skip (still counted in stat_total_pkts) */
	}

	key.proto = proto;

	/* ---- L4: TCP / UDP only ---- */
	unsigned int l4_hdr_len, payload_len;
	uint32_t seq = 0;
	int is_tcp = 0;

	if (proto == IPPROTO_TCP) {
		if (l4_avail < sizeof(struct tcphdr)) return;
		const struct tcphdr *tcp = (const struct tcphdr *)l4;
		l4_hdr_len = tcp->th_off * 4;
		if (l4_hdr_len < sizeof(struct tcphdr) || l4_avail < l4_hdr_len) return;
		key.sport = ntohs(tcp->th_sport);
		key.dport = ntohs(tcp->th_dport);
		seq = ntohl(tcp->th_seq);
		is_tcp = 1;
		payload_len = (l4_avail > l4_hdr_len) ? l4_avail - l4_hdr_len : 0;
		stat_tcp_pkts++;
		stat_tcp_bytes += h->len;

	} else if (proto == IPPROTO_UDP) {
		if (l4_avail < sizeof(struct udphdr)) return;
		const struct udphdr *udp = (const struct udphdr *)l4;
		l4_hdr_len = sizeof(struct udphdr);           /* UDP header is 8 bytes */
		key.sport = ntohs(udp->uh_sport);
		key.dport = ntohs(udp->uh_dport);
		{
			unsigned int ulen = ntohs(udp->uh_ulen);
			payload_len = (ulen >= 8) ? ulen - 8 : 0;
		}
		stat_udp_pkts++;
		stat_udp_bytes += h->len;

	} else {
		return; /* not TCP/UDP -> skip */
	}

	/* ---- filter (manual) ---- */
	if (!pass_filter(fl, &key, addr_len))
		return;

	/* ---- flow bookkeeping + retransmission check ---- */
	struct flow *f = flow_get(&key);

	int retransmit = 0;
	if (is_tcp) {
		/* Heuristic: if every byte of this data segment lies at or before
		 * the highest sequence we have already observed, we have seen it
		 * before -> retransmission. */
		uint32_t end = seq + payload_len;
		if (f->seq_valid && payload_len > 0 &&
		    (int32_t)(end - f->next_seq) <= 0)
			retransmit = 1;

		if (!f->seq_valid || (int32_t)(end - f->next_seq) > 0) {
			f->next_seq = end;
			f->seq_valid = 1;
		}
	}

	/* ---- print the line ---- */
	const u_char *payload = l4 + l4_hdr_len;
	char s_ip[INET6_ADDRSTRLEN], d_ip[INET6_ADDRSTRLEN];
	addr_str(key.family, key.src, s_ip, sizeof(s_ip));
	addr_str(key.family, key.dst, d_ip, sizeof(d_ip));

	fprintf(out,
	        "%s %s:%u -> %s:%u | hdr=%u payload=%u payload@%p%s\n",
	        proto_name(proto), s_ip, key.sport, d_ip, key.dport,
	        l4_hdr_len, payload_len, (const void *)payload,
	        retransmit ? "  [Retransmitted]" : "");
}

/* --------------------------------------------------------------- stats */

static void print_stats(void)
{
	fprintf(out, "\n===== STATISTICS =====\n");
	fprintf(out, "Total network flows        : %llu\n", stat_total_flows);
	fprintf(out, "  TCP flows                : %llu\n", stat_tcp_flows);
	fprintf(out, "  UDP flows                : %llu\n", stat_udp_flows);
	fprintf(out, "Total packets received     : %llu\n", stat_total_pkts);
	fprintf(out, "  TCP packets              : %llu\n", stat_tcp_pkts);
	fprintf(out, "  UDP packets              : %llu\n", stat_udp_pkts);
	fprintf(out, "Total TCP bytes received   : %llu\n", stat_tcp_bytes);
	fprintf(out, "Total UDP bytes received   : %llu\n", stat_udp_bytes);
	fflush(out);
}

/* --------------------------------------------------------------- driver */

static pcap_t *handle = NULL;

static void on_sigint(int sig)
{
	(void)sig;
	if (handle) pcap_breakloop(handle);    /* stop live capture cleanly */
}

void help(void)
{
	printf(
	       "\n"
	       "help:\n"
	       "\t./pcap_ex\n"
	       "Options:\n"
	       "-i, Network interface name (e.g., eth0)\n"
	       "-r, Packet capture file name (e.g., test.pcap)\n"
	       "-f, Filter expression (e.g., \"port 8080\")\n"
	       "-h, Help message\n\n");
	exit(1);
}

int main(int argc, char *argv[])
{
	char errbuf[PCAP_ERRBUF_SIZE];
	char *iface = NULL, *rfile = NULL, *fexpr = NULL;
	int ch;

	if (argc < 2)
		help();

	while ((ch = getopt(argc, argv, "hi:r:f:")) != -1) {
		switch (ch) {
		case 'i': iface = optarg; break;
		case 'r': rfile = optarg; break;
		case 'f': fexpr = optarg; break;
		case 'h':
		default:  help();
		}
	}

	if (iface && rfile) {
		fprintf(stderr, "Choose either -i or -r, not both.\n");
		return 1;
	}
	if (!iface && !rfile)
		help();

	struct filter fl;
	if (parse_filter(fexpr, &fl) < 0) {
		fprintf(stderr, "Could not parse filter: \"%s\"\n", fexpr ? fexpr : "");
		return 1;
	}

	if (iface) {
		/* live capture -> write to log.txt */
		handle = pcap_open_live(iface, 65535, 1, 1000, errbuf);
		if (!handle) {
			fprintf(stderr, "pcap_open_live(%s): %s\n", iface, errbuf);
			return 1;
		}
		out = fopen(LOG_NAME, "w");
		if (!out) { perror("fopen " LOG_NAME); return 1; }
	} else {
		/* offline read -> print to terminal */
		handle = pcap_open_offline(rfile, errbuf);
		if (!handle) {
			fprintf(stderr, "pcap_open_offline(%s): %s\n", rfile, errbuf);
			return 1;
		}
		out = stdout;
	}

	/* we only decode Ethernet link layer */
	int dlt = pcap_datalink(handle);
	if (dlt == DLT_EN10MB) {
		link_hdr_len = 14;
	} else {
		fprintf(stderr, "Warning: datalink %s not Ethernet; assuming 14-byte header.\n",
		        pcap_datalink_val_to_name(dlt));
		link_hdr_len = 14;
	}

	signal(SIGINT, on_sigint);

	/* -1 = keep going until EOF (offline) or breakloop (live) */
	if (pcap_loop(handle, -1, on_packet, (u_char *)&fl) == PCAP_ERROR)
		fprintf(stderr, "pcap_loop: %s\n", pcap_geterr(handle));

	print_stats();

	pcap_close(handle);
	if (out && out != stdout) fclose(out);
	flow_table_free();
	return 0;
}
