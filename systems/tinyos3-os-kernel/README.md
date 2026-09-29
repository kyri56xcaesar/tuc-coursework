# tinyOS3 — OS Kernel Project

Operating Systems course project (TUC, winter 2021–22). Starting from **tinyOS3**, a small
educational OS running on a simulated multicore machine, I implemented core kernel features
inside the provided code.

> Not to be confused with the TinyOS for wireless sensors — see
> [`../tinyos-wsn-routing`](../tinyos-wsn-routing) for that one.

## What I implemented

- **Multithreading** (`kernel_threads.c`): processes can run multiple threads —
  `CreateThread`, `ThreadSelf`, `ThreadJoin`, `ThreadDetach`, `ThreadExit`, managed with
  per-thread control blocks (PTCBs).
- **Pipes** (`kernel_pipe.c`): `Pipe()` with a bounded buffer, blocking reads and writes,
  and separate reader/writer close.
- **Sockets** (`kernel_socket.c`): local stream sockets on ports — `Socket`, `Listen`,
  `Accept`, `Connect`, `ShutDown`. Connected sockets talk over a pair of pipes.

The rest of the kernel (scheduler, processes, devices, the `bios` VM) came with the course.

## Build and run

Linux only; needs GCC with C11 support.

```sh
make                 # build everything
./validate_api       # run the API test suite (threads, pipes, sockets)
./mtask 1 0 5 5      # dining philosophers demo
./tinyos_shell       # a small shell running on tinyOS
```

`make doc` builds the Doxygen docs into `doc/html/`. The original course README is in
[`TINYOS3_README.md`](TINYOS3_README.md).

## License

The course-provided tinyOS3 code is GPL-2.0 (see [`LICENSE`](LICENSE)).
