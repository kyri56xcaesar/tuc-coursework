Assignment 7 - Buffer Overflow Attack (ret2shellcode)
=====================================================

Files
-----
pwn.c          given vulnerable source
Makefile       given build rules (-fno-stack-protector -z execstack -no-pie)
exploit.py     builds payload.bin
payload.bin    the generated payload
gets_shim.*    local-only: re-adds gets(), which modern glibc removed
Readme.txt     this file

Note on building
----------------
The assignment ships a precompiled binary. I only had pwn.c, so I rebuilt it.
Modern glibc (>= 2.34) removed gets(), so the program no longer links as-is.
To faithfully reproduce the vulnerable behaviour I provide gets() in gets_shim.c
(unbounded read until newline) via a forced-include header, WITHOUT editing pwn.c:

  gcc -ggdb -fno-stack-protector -z execstack -Wall -no-pie \
      -include ./gets_shim.h -o bof pwn.c gets_shim.c

Because I compiled it myself, the symbol addresses are those of my build
(-no-pie keeps them constant across runs). On the original binary, read the
address of big_boy_buffer with:  readelf -s bof | grep big_boy_buffer
and update BIG_BOY in exploit.py.

The vulnerability
-----------------
vuln() reads input with gets() into char buffer[100]. gets() does no bounds
checking, so a long line overflows the stack and overwrites the saved return
address. vuln() also does memcpy(big_boy_buffer, buffer, 100), and main() has
already marked big_boy_buffer as READ|WRITE|EXEC via mprotect(). So our first
100 input bytes are copied to a fixed, executable address (0x404060 in my build).

Exploitation (ret2shellcode)
----------------------------
1. Offset to the saved return address = 120 bytes.
   buffer sits at rbp-0x70 (112 bytes to the saved rbp) + 8 for the saved rbp.
   Verified in GDB: sending 120*'A' + 8 canonical bytes set RIP to those bytes.
2. Layout of the payload:
      [ shellcode (24 B) ][ 0x90 padding up to 120 ][ 0x404060 little-endian ]
   The shellcode is execve("/bin//sh", NULL, NULL), 24 bytes, no 0x0a byte
   (gets() stops at a newline; NUL bytes are fine).
3. The first 100 bytes land in the executable big_boy_buffer; the 8-byte
   return address sends execution there on ret.

Running it
----------
  make
  python3 exploit.py payload.bin
  cat payload.bin - | ./bof          # interactive shell
or non-interactively:
  ( cat payload.bin; printf '\n'; echo 'id; echo PWNED_OK; exit' ) | ./bof

Proof it works
--------------
The run above prints, from the spawned /bin/sh:
  uid=1000(kyri) gid=1000(kyri) groups=1000(kyri),...
  PWNED_OK
i.e. our shellcode executed and we controlled the process.
