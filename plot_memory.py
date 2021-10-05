#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# dataframe_strong = pd.read_csv("strong_singlegrid_444444.csv")
# dataframe_strong = pd.read_csv("pre_init.csv")
# dataframe_strong = pd.read_csv("at_creation_worker_nothirdlevel.csv")
# dataframe_strong = pd.read_csv("at_creation_worker.csv",comment='#')
# dataframe_strong = pd.read_csv("after_lcomm.csv",comment='#')
dataframe_strong = pd.read_csv("firstthing.csv",comment='#')

dataframe_strong["squared"] = dataframe_strong["nprocesses"]**2


plotfcn = plt.loglog
# plotfcn = plt.plot

plotfcn(dataframe_strong["nprocesses"],
                 dataframe_strong["VmRSS"], label="VmRSS")

dataframe_strong["VmRSSPerProcess"] = dataframe_strong["VmRSS"]/(dataframe_strong["nprocesses"])
plotfcn(dataframe_strong["nprocesses"],
                 dataframe_strong["VmRSSPerProcess"], label="VmRSSPerProcess")

# dataframe_strong["RSSMinusOverhead"] = dataframe_strong["VmRSS"]-(dataframe_strong["nprocesses"]*16000)
# plt.semilogx(dataframe_strong["nprocesses"],
#                  dataframe_strong["RSSMinusOverhead"], label="RSSMinusOverhead")

plotfcn(dataframe_strong["nprocesses"],
                 dataframe_strong["VmSize"], label="VmSize")

dataframe_strong["VmSizePerProcess"] = dataframe_strong["VmSize"]/(dataframe_strong["nprocesses"])
plotfcn(dataframe_strong["nprocesses"],
                 dataframe_strong["VmSizePerProcess"], label="VmSizePerProcess")

dataframe_strong["VmSizeMinusOverhead"] = dataframe_strong["VmSize"]-(dataframe_strong["nprocesses"]*180000)
plotfcn(dataframe_strong["nprocesses"],
                 dataframe_strong["VmSizeMinusOverhead"], label="VmSizeMinusOverhead")

plotfcn(dataframe_strong["nprocesses"],
                 dataframe_strong["squared"]*1e3, label="nprocesses^2")
plotfcn(dataframe_strong["nprocesses"],
                 dataframe_strong["nprocesses"]*1e6, label="nprocesses")


plt.legend()
plt.show()
