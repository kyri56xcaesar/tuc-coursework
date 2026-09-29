# Computer Security Assignments

Assignments for the Security of Systems and Services course (TUC). Most are in C on Linux;
each folder has its own `Makefile` and notes.

| Folder | Topic |
|--------|-------|
| [`simple_crypto/`](simple_crypto) | Classic ciphers: one-time pad, Caesar, Vigenère |
| [`assignment1/`](assignment1) | **Diffie–Hellman** key exchange and **RSA** key generation, encryption and decryption, using GMP (`dh_assign_1`, `rsa_assign_1`) |
| [`assignment2/`](assignment2) | **TLS client/server** with OpenSSL: the server (run as root) loads a certificate and key, accepts TLS connections and checks the username and password the client sends |
| [`assignment3/`](assignment3) | **Access-control logging**: a shared library (`logger.c`) that hooks `fopen`/`fwrite` with `LD_PRELOAD` and logs every file access with hashes; `acmonitor` reads the log to find unauthorized accesses and file changes |
| [`assignment4/`](assignment4) | **Web security**: SQL injection (login bypass, `UNION` attack) against a Flask app in Docker (`corpus/public/`); the steps are in `2018030043_assign4.txt` |

## Build

```sh
sudo apt install build-essential libssl-dev libgmp-dev
cd assignment1 && make
```

The assignment 4 target runs with Docker: `cd assignment4/corpus/public && ./run.sh`.
