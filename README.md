# TUC Coursework

A collection of my university projects and assignments from the
**School of Electrical and Computer Engineering, Technical University of Crete (TUC)**.

Each project used to live in its own GitHub repository. They were merged here with
`git subtree`, so the **full commit history of every project is preserved** — run
`git log -- <project-folder>` to see it.

## Projects

| Area | Project | What it is | Tech |
|------|---------|------------|------|
| Systems | [`systems/tinyos3-os-kernel`](systems/tinyos3-os-kernel) | Threads, pipes and sockets implemented inside tinyOS3, a small educational OS kernel | C |
| Systems | [`systems/tinyos-wsn-routing`](systems/tinyos-wsn-routing) | Routing-tree construction and data aggregation for wireless sensor networks, simulated with TOSSIM (PLH511) | nesC, TinyOS, Python |
| Hardware | [`hardware/single-cycle-cpu-vhdl`](hardware/single-cycle-cpu-vhdl) | A 32-bit single-cycle CPU designed in VHDL, with testbenches for each component | VHDL |
| AI | [`ai/reinforcement-learning`](ai/reinforcement-learning) | Multi-armed bandits (UCB) and experts vs. bandit algorithms for online stock selection | Python |
| AI | [`ai/path-finding-sim`](ai/path-finding-sim) | A*, IDA* and DFS motion planners for CommonRoad driving scenarios, with a visual simulation | Python |
| Security | [`security/csec-assignments`](security/csec-assignments) | Cryptography (DH, RSA, classic ciphers), TLS client/server, access-control logging, SQL injection | C, OpenSSL, Python |
| Big Data | [`big-data/spark-scala-analytics`](big-data/spark-scala-analytics) | Apache Spark jobs on HDFS: Reuters document analysis (RDDs) and AIS vessel-tracking queries (DataFrames) | Scala, Spark, HDFS |
| Software Eng. | [`software-engineering/tweet-editor`](software-engineering/tweet-editor) | Command-line Twitter viewer & editor taken through development, logging, testing, profiling and refactoring (PLH211) | Python |

## Layout

```
tuc-coursework/
├── ai/
│   ├── path-finding-sim/
│   └── reinforcement-learning/
├── big-data/
│   └── spark-scala-analytics/
├── hardware/
│   └── single-cycle-cpu-vhdl/
├── security/
│   └── csec-assignments/
├── software-engineering/
│   └── tweet-editor/
└── systems/
    ├── tinyos-wsn-routing/
    └── tinyos3-os-kernel/
```

## Where things came from

| Folder | Original repository |
|--------|---------------------|
| `ai/reinforcement-learning` | `kyri56xcaesar/RL-journey` |
| `ai/path-finding-sim` | `kyri56xcaesar/path-finding-algos-implementation-sim` |
| `systems/tinyos3-os-kernel` | `kyri56xcaesar/tinyos3-myproject` |
| `systems/tinyos-wsn-routing` | `kyri56xcaesar/tinyOS` |
| `hardware/single-cycle-cpu-vhdl` | `kyri56xcaesar/ComputerOrganisationSingleCycle` |
| `security/csec-assignments` | `kyri56xcaesar/some-csec-thematics` |
| `big-data/spark-scala-analytics` | `kyri56xcaesar/FP_project` |
| `software-engineering/tweet-editor` | `kyri56xcaesar/TwitterLike-editor` |

### Archived side branches

Some of the original repositories had unmerged side branches. They are kept as tags
(with their original history, at the original file layout):

| Tag | Contents |
|-----|----------|
| `archive/spark-scala-analytics/on_cluster` | Spark jobs set up for the TUC SoftNet YARN cluster, with `build.sbt` |
| `archive/tinyos-wsn-routing/python2_version` | Later work (part 1 of the aggregation phase) and extra topologies |
| `archive/tweet-editor/mem_profiling` | Early memory-profiling experiments |
| `archive/tweet-editor/profiling_v2` | Profiling version with a task handler in `main` |

To check one out: `git checkout archive/tweet-editor/profiling_v2`.

## License

GPL-3.0 — see [LICENSE](LICENSE). `systems/tinyos3-os-kernel` also includes the
course-provided tinyOS3 code, which is under its own GPL-2.0 [LICENSE](systems/tinyos3-os-kernel/LICENSE).
