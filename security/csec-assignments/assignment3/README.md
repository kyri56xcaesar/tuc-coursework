# Assignment 3 — Access-control logging

**Name:** Kyriakos Chalvatzis
**AM:** 2018030043

## Components

- **`logger.c` / `logger.so`** — a shared library, loaded with `LD_PRELOAD`,
  that hooks `fopen` and `fwrite`. For every file access it records an entry
  (uid, access type, whether the action was denied, date/time, filename and an
  MD5 fingerprint of the file) into `file_logging.log`.
- **`acmonitor.c` / `acmonitor`** — reads `file_logging.log` and answers:
  - `-m` — which users are malicious (attempted accesses that were denied);
  - `-i <file>` — which users modified `<file>`, and how many times;
  - `-h` — usage.

## Build & run

```sh
make                                   # builds logger.so, acmonitor, test_aclog
LD_PRELOAD=./logger.so ./test_aclog    # generate log entries
./acmonitor -m
./acmonitor -i file_0
```

## Log format parsed by acmonitor

Each entry (written by `logger.c`) has a fixed field order:

```
=============== ENTRY ===============
uid: <int>
access_type: <0..3>      # 0 create, 1 open/read, 2 write, 3 empty
action_denied: <0|1>     # 1 = access denied (EACCES)
date: <date>
time: <time>
file: <filename>
fingerprint: <md5 hex>
=====================================
```

## acmonitor implementation

`next_record()` parses one entry at a time by matching the field prefixes; the
`fingerprint:` line is last, so reading it completes a record.

- **`list_unauthorized_accesses` (`-m`)** — counts, per uid, the entries with
  `action_denied == 1`, and prints each such user with its count. A user that
  tried to reach files it is not allowed to is flagged as malicious.
- **`list_file_modifications` (`-i`)** — scans entries for the given file in
  order and counts a modification whenever the **fingerprint changes** from the
  previously seen one for that file, crediting it to that entry's uid. The first
  sighting establishes the baseline, and a write that does not change the
  content (same fingerprint) is not counted. This detects *real* content
  changes rather than merely counting write calls.

## Note on the provided logger

On a current toolchain (glibc ≥ 2.34, GMP 6.x) `logger.so` segfaults during
key generation: `mpz_out_str()` writes through `fwrite`, which the library
itself hooks, and the hook dereferences the not-yet-set `file_opened` path
(`logger.c:113`, via `check_if_empty_file`). This is a reentrancy issue in the
provided logging/encryption code, independent of `acmonitor`. `acmonitor` was
therefore validated against a log produced in the exact format above.

The missing `encryption/util.h` (lost with the rest of the assignment) is
reconstructed: it provides `lambda_euler_function` (Carmichael λ = lcm(p−1,q−1))
and `forge_d_key` (an exponent coprime to λ) used by `key_generation`.
