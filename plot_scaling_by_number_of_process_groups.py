#!/usr/bin/env python3

"""Script for outputting the average runtimes output by the stats class
"""

import sys
import json
import matplotlib.patches as mpatch
import matplotlib.ticker as ticker
import matplotlib.pyplot as plt
import numpy as np
from itertools import cycle
from plot_scaling_by_process_group_size import print_csv, print_mean_std, print_maxtime, print_mintime

# list of distinguishable colors, see:
# https://graphicdesign.stackexchange.com/revisions/3815/8
color_list = ["#FFFF00","#1CE6FF","#FF34FF","#FF4A46","#008941","#006FA6",
              "#A30059","#FFDBE5","#7A4900","#0000A6","#63FFAC","#B79762",
              "#004D43","#8FB0FF","#997D87","#5A0007","#809693","#FEFFE6",
              "#1B4400","#4FC601","#3B5DFF","#4A3B53","#FF2F80","#61615A",
              "#BA0900","#6B7900","#00C2A0","#FFAA92","#FF90C9","#B903AA",
              "#D16100","#DDEFFF","#000035","#7B4F4B","#A1C299","#300018",
              "#0AA6D8","#013349","#00846F","#372101","#FFB500","#C2FFED",
              "#A079BF","#CC0744","#C0B9B2","#C2FF99","#001E09","#00489C",
              "#6F0062","#0CBD66","#EEC3FF","#456D75","#B77B68","#7A87A1",
              "#788D66","#885578","#FAD09F","#FF8A9A","#D157A0","#BEC459",
              "#456648","#0086ED","#886F4C","#34362D","#B4A8BD","#00A6AA",
              "#452C2C","#636375","#A3C8C9","#FF913F","#938A81","#575329",
              "#00FECF","#B05B6F","#8CD0FF","#3B9700","#04F757","#C8A1A1",
              "#1E6E00","#7900D7","#A77500","#6367A9","#A05837","#6B002C",
              "#772600","#D790FF","#9B9700","#549E79","#FFF69F","#201625",
              "#72418F","#BC23FF","#99ADC0","#3A2465","#922329","#5B4534",
              "#FDE8DC","#404E55","#0089A3","#CB7E98","#A4E804","#324E72",
              "#6A3A4C","#83AB58","#001C1E","#D1F7CE","#004B28","#C8D0F6",
              "#A3A489","#806C66","#222800","#BF5650","#E83000","#66796D",
              "#DA007C","#FF1A59","#8ADBB4","#1E0200","#5B4E51","#C895C5",
              "#320033","#FF6832","#66E1D3","#CFCDAC","#D0AC94","#7ED379",
              "#012C58","#7A7BFF","#D68E01","#353339","#78AFA1","#FEB2C6",
              "#75797C","#837393","#943A4D","#B5F4FF","#D2DCD5","#9556BD",
              "#6A714A","#001325","#02525F","#0AA3F7","#E98176","#DBD5DD",
              "#5EBCD1","#3D4F44","#7E6405","#02684E","#962B75","#8D8546",
              "#9695C5","#E773CE","#D86A78","#3E89BE","#CA834E","#518A87",
              "#5B113C","#55813B","#E704C4","#00005F","#A97399","#4B8160",
              "#59738A","#FF5DA7","#F7C9BF","#643127","#513A01","#6B94AA",
              "#51A058","#A45B02","#1D1702","#E20027","#E7AB63","#4C6001",
              "#9C6966","#64547B","#97979E","#006A66","#391406","#F4D749",
              "#0045D2","#006C31","#DDB6D0","#7C6571","#9FB2A4","#00D891",
              "#15A08A","#BC65E9","#FFFFFE","#C6DC99","#203B3C","#671190",
              "#6B3A64","#F5E1FF","#FFA0F2","#CCAA35","#374527","#8BB400",
              "#797868","#C6005A","#3B000A","#C86240","#29607C","#402334",
              "#7D5A44","#CCB87C","#B88183","#AA5199","#B5D6C3","#A38469",
              "#9F94F0","#A74571","#B894A6","#71BB8C","#00B433","#789EC9",
              "#6D80BA","#953F00","#5EFF03","#E4FFFC","#1BE177","#BCB1E5",
              "#76912F","#003109","#0060CD","#D20096","#895563","#29201D",
              "#5B3213","#A76F42","#89412E","#1A3A2A","#494B5A","#A88C85",
              "#F4ABAA","#A3F3AB","#00C6C8","#EA8B66","#958A9F","#BDC9D2",
              "#9FA064","#BE4700","#658188","#83A485","#453C23","#47675D",
              "#3A3F00","#061203","#DFFB71","#868E7E","#98D058","#6C8F7D",
              "#D7BFC2","#3C3E6E","#D83D66","#2F5D9B","#6C5E46","#D25B88",
              "#5B656C","#00B57F","#545C46","#866097","#365D25","#252F99",
              "#00CCFF","#674E60","#FC009C","#92896B"]

def color_pool(proc):
    """assigns a specific color to each event
    """
    color_cycler = cycle(color_list)
    color_map = {}
    for i in range(len(proc)):
        data = "rank" + str(i)
        for event in proc[data]["events"]:
            if event not in color_map:
                color_map[event] = next(color_cycler)
    return color_map

def color_pool_from_event_list(events):
    """assigns a specific color to each event
    """
    color_cycler = cycle(color_list)
    color_map = {}
    for event in events:
        if event not in color_map:
            color_map[event] = next(color_cycler)
    return color_map

def bar_plot_worker_group_managers(times, colors, stacked = False):
    """plots the average times of the process groups
    """
    labels = set()

    fig, ax = plt.subplots()
    ax.semilogy()
    ax.set_xlabel('number of process groups')
    ax.set_ylabel('time (s)')
    ax.grid(True)
    ax.set_axisbelow(True)

    xticks = []
    xlables = []
    offset = 0
    group = 0
    print("number of process groups, event, mean, std")
    for t in times:
        if (stacked):
            xticks.append(offset)
        else:
            xticks.append(offset + len(colors) - 1)
        xlables.append(t)
        bottommean = None
        for i in times[t]:
            # only add the events that have colors
            if i in colors:
                mean = np.mean(times[t][i])
                std = np.std(times[t][i])
                ax.bar(offset, mean, 2, color=colors[i],
                    bottom=bottommean,
                    edgecolor="black", linewidth=1,
                    yerr=std,
                    label=i if i not in labels else "_nolegend_",
                    error_kw=dict(elinewidth=1,ecolor='black',
                                    capsize=2,capthick=1))
                # print the data that went into this plot
                print(t, ",", i, ",", mean, ",", std)
                if (stacked):
                    bottommean = np.mean(times[t][i])
                else:
                    offset += 2
                labels.add(i)
        offset += 8
        group += 1

    ax.set_xticks(xticks)
    ax.set_xticklabels(xlables)
    ax.legend(loc=2).get_frame().set_alpha(0.75)

    # use seconds as unit
    scale_y = 1e6
    ticks_y = ticker.FuncFormatter(lambda y, pos: "{0:g}".format(y/scale_y))
    ax.yaxis.set_major_formatter(ticks_y)

def get_master_ranks(proc):
    group_old = -1
    master_ranks = []
    # do not count the manager
    for rank in range(len(proc) - 1):
        data = "rank" + str(rank)
        if bool(int(proc[data]["attributes"]["group_manager"])):
            group = int(proc[data]["attributes"]["group"])
            assert(group > group_old)
            group_old = group
            master_ranks.append(rank)
    return master_ranks

def get_num_groups(proc):
    return len(get_master_ranks(proc))

def get_num_runfirst(proc, rank=0):
    num_run_first = 0
    data = "rank" + str(rank)
    for i in proc[data]["events"]:
        if (i == "worker run first"):
            num_run_first += len(proc[data]["events"][i])
    assert (num_run_first > 0)
    return num_run_first

def get_times_from_json(procs, ranks_to_get_times_from=[]):
    times = {}
    for p in range(len(procs)):
        proc = procs[p]
        numGroups = get_num_groups(proc)
        # check if this was a third-level run
        #print(proc["rank0"]["events"])
        if "combineThirdLevel" in proc["rank0"]["events"].keys():
            # add the one remote process group
            numGroups += 1
        # print(numGroups, get_master_ranks(proc))
        if numGroups not in times:
            times[numGroups] = {}
        times[numGroups]["run all tasks"] = []
        if ranks_to_get_times_from == []:
            ranks = get_master_ranks(proc)
        else:
            ranks = ranks_to_get_times_from
        try:
            for rank in ranks:
                if rank == -1:
                    num_tasks = 0
                    rank = len(proc) - 1
                else:
                    num_tasks = get_num_runfirst(proc, rank)
                data = "rank" + str(rank)
                # print(data)
                group = int(proc[data]["attributes"]["group"])
                assert bool(int(proc[data]["attributes"]["group_manager"]))
                num_worker_run = 0
                time_run_all = 0.
                for i in proc[data]["events"]:
                    # print(i)
                    if i not in times[numGroups]:
                        times[numGroups][i] = []
                    event_no=0
                    for j in proc[data]["events"][i]:
                        duration = j[1] - j[0]
                        # leave out first combination, because it makes weird things happen on NG
                        if (i != "combine" and i != "manager combine") or event_no > 0 :
                            times[numGroups][i].append(duration)
                        if i == "worker run":
                            num_worker_run += 1
                            time_run_all += duration
                            # every time we have n_tasks "worker run" events,
                            # add a new duration for "run all tasks"
                            if (num_worker_run % num_tasks == 0):
                                times[numGroups]["run all tasks"].append(time_run_all)
                                time_run_all = 0
                        event_no += 1
                    # remove last combination, as it might have used more subspaces
                    if i == "worker combine" or i == "combine" or i == "manager combine":
                        times[numGroups][i] = times[numGroups][i][:-1]

                if ranks_to_get_times_from != [-1]:
                    assert (num_worker_run > 0)
                    assert (num_worker_run % num_tasks == 0)
            if ranks_to_get_times_from != [-1]:
                print (len(times[numGroups]["run all tasks"]), len(times[numGroups]["combine"]))
                assert (len(times[numGroups]["run all tasks"]) == len(times[numGroups]["combine"]) + len(ranks))
            else:
                print (len(times[numGroups]["manager run"]), len(times[numGroups]["manager combine"]))
            #    assert (len(times[numGroups]["manager run"]) == len(times[numGroups]["manager combine"]) + len(ranks))
            # print(num_worker_run, num_tasks)
        except Exception as err:
            raise err
            # raise RuntimeError("rank " + str(rank) +
            #                 " is missing attribute " + str(err))
    times_sorted = {}
    for i in sorted(times):
        times_sorted[i]=times[i]
    return times_sorted

if __name__ == "__main__":
    # if len(sys.argv) == 1:
    #     raise RuntimeError("no input file specified")
    # if len(sys.argv) > 2:
    #     raise RuntimeError("too many command line arguments")
    
    # all timers.json files are passed as input
    proc = [ json.load(open(sys.argv[i]))  for i in range(1, len(sys.argv))]
    
    
    # print("Choose type of plot:")
    # print("1 (timeline all processes),")
    # print("2 (timeline group managers),")
    # print("3 (average time all processes),")
    # print("4 (max total-times of all processes),")
    # print("5 (average time process groups)")
    # plot_type = int(input("\n"))
    
    # use manager rank (-1)
    manager_times = get_times_from_json(proc, [-1])
    print_mean_std(manager_times)
    print_maxtime(manager_times, "manager combine")
    print_mintime(manager_times, "manager combine")


    # colors = color_pool(proc[0])
    colors = color_pool_from_event_list(["combine", "run all tasks"])
    # colors = color_pool_from_event_list(["combine"])
    events_manager = ["manager combine", "manager run", "manager write to disk", "manager read from disk"]
    colors = color_pool_from_event_list(events_manager)
    #colors = color_pool_from_event_list(["manager run"])

    print_csv(manager_times, events_manager)

    bar_plot_worker_group_managers(manager_times, colors, True)
    
    plt.tight_layout()
    plt.show()
