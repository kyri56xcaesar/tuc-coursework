#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "logger.h"


void
usage(void)
{
	printf(
	       "\n"
	       "usage:\n"
	       "\t./monitor \n"
		   "Options:\n"
		   "-m, Prints malicious users\n"
		   "-i <filename>, Prints table of users that modified "
		   "the file <filename> and the number of modifications\n"
		   "-h, Help message\n\n"
		   );

	exit(1);
}


/*
 * One parsed log record. The log is a sequence of entries in the fixed field
 * order written by logger.c:
 *
 *   =============== ENTRY ===============
 *   uid: <int>
 *   access_type: <0..3>      0=create 1=open/read 2=write 3=empty
 *   action_denied: <0|1>     1 = access was denied (EACCES)
 *   date: <date>
 *   time: <time>
 *   file: <filename>
 *   fingerprint: <md5 hex>
 *   =====================================
 */
struct rec {
	int  uid;
	int  access_type;
	int  action_denied;
	char date[64];
	char time[64];
	char file[512];
	char fingerprint[128];
};

/* strip a trailing '\n' */
static void chomp(char *s)
{
	size_t n = strlen(s);
	if (n && s[n - 1] == '\n')
		s[n - 1] = '\0';
}

/* Read the next entry from the log. The fingerprint line is last, so once we
 * have it the record is complete. Returns 1 on success, 0 at EOF. */
static int next_record(FILE *log, struct rec *r)
{
	char line[1024];
	int have = 0;

	memset(r, 0, sizeof(*r));
	while (fgets(line, sizeof(line), log)) {
		chomp(line);
		if (strncmp(line, "uid: ", 5) == 0) {
			r->uid = atoi(line + 5);
			have = 1;
		} else if (strncmp(line, "access_type: ", 13) == 0) {
			r->access_type = atoi(line + 13);
		} else if (strncmp(line, "action_denied: ", 15) == 0) {
			r->action_denied = atoi(line + 15);
		} else if (strncmp(line, "date: ", 6) == 0) {
			strncpy(r->date, line + 6, sizeof(r->date) - 1);
		} else if (strncmp(line, "time: ", 6) == 0) {
			strncpy(r->time, line + 6, sizeof(r->time) - 1);
		} else if (strncmp(line, "file: ", 6) == 0) {
			strncpy(r->file, line + 6, sizeof(r->file) - 1);
		} else if (strncmp(line, "fingerprint: ", 13) == 0) {
			strncpy(r->fingerprint, line + 13, sizeof(r->fingerprint) - 1);
			return 1;     /* last field -> entry complete */
		}
	}
	return 0;
	(void)have;
}


/*
 * -m : print the users that attempted an access that was denied. A user that
 *      repeatedly tries to reach files they are not allowed to is flagged as
 *      malicious. We count the denied accesses per uid and print them.
 */
void
list_unauthorized_accesses(FILE *log)
{
	int   uids[4096];
	int   count[4096];
	int   n = 0;
	struct rec r;

	rewind(log);
	while (next_record(log, &r)) {
		if (r.action_denied != 1)
			continue;

		int i;
		for (i = 0; i < n; i++)
			if (uids[i] == r.uid) { count[i]++; break; }
		if (i == n && n < (int)(sizeof(uids) / sizeof(uids[0]))) {
			uids[n] = r.uid;
			count[n] = 1;
			n++;
		}
	}

	if (n == 0) {
		printf("No unauthorized (denied) accesses found.\n");
		return;
	}

	printf("Malicious users (denied accesses):\n");
	for (int i = 0; i < n; i++)
		printf("  uid %d : %d denied access(es)\n", uids[i], count[i]);

	return;
}


/*
 * -i <file> : print, per user, how many times they modified <file>. A real
 *             modification is detected from the file fingerprint changing
 *             between consecutive log entries for that file (a write that does
 *             not change the content is not counted). The first time the file
 *             is seen only establishes the baseline fingerprint.
 */
void
list_file_modifications(FILE *log, char *file_to_scan)
{
	int   uids[4096];
	int   count[4096];
	int   n = 0;
	char  last_fp[128] = "";
	int   seen = 0;
	struct rec r;

	rewind(log);
	while (next_record(log, &r)) {
		if (strcmp(r.file, file_to_scan) != 0)
			continue;

		if (!seen) {
			/* first observation of the file: baseline, not a change */
			strncpy(last_fp, r.fingerprint, sizeof(last_fp) - 1);
			seen = 1;
			continue;
		}

		if (strcmp(r.fingerprint, last_fp) == 0)
			continue;                 /* content unchanged */

		strncpy(last_fp, r.fingerprint, sizeof(last_fp) - 1);

		int i;
		for (i = 0; i < n; i++)
			if (uids[i] == r.uid) { count[i]++; break; }
		if (i == n && n < (int)(sizeof(uids) / sizeof(uids[0]))) {
			uids[n] = r.uid;
			count[n] = 1;
			n++;
		}
	}

	if (!seen) {
		printf("No log entries for file \"%s\".\n", file_to_scan);
		return;
	}
	if (n == 0) {
		printf("File \"%s\" was not modified after creation.\n", file_to_scan);
		return;
	}

	printf("Modifications of \"%s\":\n", file_to_scan);
	for (int i = 0; i < n; i++)
		printf("  uid %d : %d modification(s)\n", uids[i], count[i]);

	return;
}


int 
main(int argc, char *argv[])
{

	int ch;
	FILE *log;

	if (argc < 2)
		usage();

	log = fopen("./file_logging.log", "r");
	if (log == NULL) {
		printf("Error opening log file \"%s\"\n", "./log");
		return 1;
	}

	while ((ch = getopt(argc, argv, "hi:m")) != -1) {
		switch (ch) {		
		case 'i':
			list_file_modifications(log, optarg);
			break;
		case 'm':
			list_unauthorized_accesses(log);
			break;
		default:
			usage();
		}

	}


	/* add your code here */
	/* ... */
	/* ... */
	/* ... */
	/* ... */


	fclose(log);
	argc -= optind;
	argv += optind;	
	
	return 0;
}
