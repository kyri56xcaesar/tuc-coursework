# Twitter Viewer & Editor

Group project for **PLH211** (TUC, fall 2022). A command-line tool that loads a large file of
tweets (one JSON object per line) into memory and lets you browse and edit it. The project
went through several stages: development, logging, unit testing, profiling and refactoring.

## Commands

| Key | Action |
|-----|--------|
| `c` | Create a tweet |
| `r` | Read a tweet by ID |
| `u` | Update a tweet |
| `d` | Delete the current tweet |
| `$` | Read the last tweet |
| `-` / `+` | Previous / next tweet |
| `=` | Print the current tweet |
| `w` | Save to file |
| `x` | Save and quit |
| `q` | Quit without saving |
| `h` | Help |

## Files by stage

| Stage | Files |
|-------|-------|
| Development | `development_phase.py` |
| Logging | `mylogging.py`, `conifgfile.conf` (log to `logme.txt`) |
| Unit testing | `dev-unit-testing.py`, `ref-unit-testing.py` |
| Profiling | `dev-time-profiler.py`, `dev-mem-profiler.py`, `ref-time-profiler.py`, `ref-mem-profiler.py` |
| Refactoring | `refactoring.py` (idiomatic Python, based on the profiling results) |
| Report | `PLH211_Project1_2022_2023.ipynb` (in Greek) |

## Running

```sh
pip install memory_profiler line_profiler   # only needed for profiling
python refactoring.py
```

The input file is set at the top of the script (`FILE_NAME` in `refactoring.py`). `test.json` is a small sample;
the full dataset (`tweetdhead300000.json`) is not included.

Earlier profiling experiments are on the `archive/tweet-editor/mem_profiling` and
`archive/tweet-editor/profiling_v2` tags of this repository.
