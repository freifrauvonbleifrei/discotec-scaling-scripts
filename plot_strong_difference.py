#!/usr/bin/env python3

import sys
import json
import matplotlib.patches as mpatch
import matplotlib.ticker as ticker
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from itertools import cycle

assert(len(sys.argv) == 3)
# all csv files are passed as input
old = pd.read_csv(sys.argv[1])
old.rename(columns=lambda x: x.strip()+"_", inplace=True)
new = pd.read_csv(sys.argv[2])
new.rename(columns=lambda x: x.strip()+"_", inplace=True)

print(old.columns)

old_where_run = ["manager run" in n for n in old["event_"]]
old_run = old[old_where_run]
old_run.reset_index(inplace=True)
old_where_combine = ["manager combine" in n for n in old["event_"]]
old_combine = old[old_where_combine]
old_combine.reset_index(inplace=True)

new_where_run = ["manager run" in n for n in new["event_"]]
new_run = new[new_where_run]
new_run.reset_index(inplace=True)
new_where_combine = ["manager combine" in n for n in new["event_"]]
new_combine = new[new_where_combine]
new_combine.reset_index(inplace=True)

# diff_run = new_run.copy()
# diff_run[" mean"] -= old_run[" mean"]

# print(diff_run)

diff_run = new_run.copy()
diff_run["mean_"] = new_run.mean_ - old_run.mean_
diff_run["std_"] = new_run.std_ - old_run.std_
print(diff_run.to_csv())

diff_combine = new_combine.copy()
diff_combine["mean_"] = new_combine.mean_ - old_combine.mean_
diff_combine["std_"] = new_combine.std_ - old_combine.std_
print(diff_combine.to_csv())
print(diff_combine["mean_"].mean(), diff_combine["mean_"].std())
diff_combine.to_csv()
