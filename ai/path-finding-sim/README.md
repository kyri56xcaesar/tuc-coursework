# Path-Finding Motion Planner Simulation

Semester project for the Artificial Intelligence course (TUC, 2022). Search algorithms plan
a route for an autonomous vehicle through
[CommonRoad](https://commonroad.in.tum.de/) traffic scenarios, and the search is drawn step
by step.

## What's inside

The vehicle moves using **motion primitives**: short, precomputed trajectories chained
together by a maneuver automaton (BMW 320i model). The planners search this graph from the
start state to the goal region while avoiding obstacles.

| Algorithm | File |
|-----------|------|
| A* | `ai_assignment1/Algorithms/Astar.py` |
| Iterative Deepening A* (IDA*) | `ai_assignment1/Algorithms/IDAstar.py` |
| Depth-First Search (example) | `ai_assignment1/Algorithms/DFS_example.py` |

- `SMP/`: CommonRoad search framework provided with the course (motion planner base, maneuver
  automaton, plotting).
- `Scenarios/`: three test scenarios (`scenario1.xml` to `scenario3.xml`).
- `Figures/`: saved snapshots of solutions at different search steps.

## Running

Linux, Python 3.

```sh
cd ai_assignment1
pip install -r requirements.txt
python main.py
```

In `main.py` you choose the scenario (`path_scenario`) and which planners to run
(`dict_motion_planners`).
