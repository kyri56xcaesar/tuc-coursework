# Reinforcement Learning Assignments

Assignments for the Reinforcement Learning course (TUC, 2024), about online learning with
bandits and experts.

## Assignment 1 — Multi-armed bandits for news recommendation

A site shows one of `K = 5` articles to each visiting user. How likely a user is to click
each article depends on the user's group (female over 25, male over 25, under 25). The
algorithm has to learn which article to show each group to get the most clicks.

- Implements **UCB** (Upper Confidence Bound):
  `ucb_i(t) = μ_i(t) + sqrt(2 log T / N_i(t))`
- Measures regret against always showing each group its best article, and plots raw,
  cumulative and per-step regret over `T = 1000` rounds.
- Files: `assignment1.py`, the notebook `assignment1.ipynb`, results in
  `RL_assigment1_2018030043_plot_report.pdf` and `Figure_1.png`.

## Assignment 2 — Experts vs. bandits for stock selection

Each day an investor picks one stock from a `stocks.csv` price history. All three settings
use **multiplicative weights** (`w_i ← w_i · exp(-ε · regret_i)`):

- **Experts**: after each day the change of every stock is known, and all weights are updated.
- **Experts with transaction fees**: same, but each stock has a fee that is taken off the profit.
- **Bandit**: only the chosen stock's result is known, so only its weight is updated.

Plots daily profit and regret for each setting. Files: `assignment2.py` and
`assigment2.ipynb`. `stocks.csv` is not included in the repository.

## Running

```sh
pip install numpy pandas matplotlib
python assignment1/assignment1.py
python assignment2/assignment2.py   # needs stocks.csv in the working directory
```
