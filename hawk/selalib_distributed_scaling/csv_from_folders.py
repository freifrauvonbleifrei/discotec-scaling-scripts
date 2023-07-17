#!/usr/bin/env python3

"""Script for aggregating timing measurements into a csv file"""

import argparse
from icecream import ic
import pandas as pd
import subprocess
from io import StringIO

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_folders", nargs='*', type=str, help="the input folders, must contain timers*.json files and $ngroups x $nprocs in folder name", required=True)
    parser.add_argument("--evalscript", type=str, help="path to script DisCoTec/tools/evaluate.py", required=True)
    parser.add_argument("--output_csv", type=str, default="discotec_scaling.csv")
    args = parser.parse_args()
    ic(args.input_folders)

    list_of_dataframes = []
    # each folder should add a line to our aggregated csv file
    for folder in args.input_folders:
        # get number of groups / processes from folder name
        folder_numbers = [int(s) for s in folder.replace('x',' ').replace('-',' ').replace('_',' ').replace('/',' ').split() if s.isdigit()]
        ic(folder_numbers)
        try:
            assert(len(folder_numbers) == 2)
        except AssertionError:
            continue
        basis_function = folder.replace('x',' ').replace('-',' ').replace('_',' ').replace('/',' ').split()[-2]
        ic(basis_function)
        numGroups = folder_numbers[0]
        numProcsPerGroup = folder_numbers[1]

        try:
            # execute evaluate script in the folder, capture the output
            output = subprocess.run(["python " + args.evalscript + " --input_files timers*json --no_compute_per_rank_statistics --no_compute_per_step_statistics --no_tqdm"], check=True, stdout=subprocess.PIPE, cwd=folder, shell=True).stdout
        except subprocess.CalledProcessError:
            continue

        # keep only the last two lines of the output
        output = output.splitlines()[-2].decode('utf-8') + '\n' + output.splitlines()[-1].decode('utf-8')
        #ic(output)

        # store output as pandas dataframe with one row
        partial_df = pd.read_csv(StringIO(output), sep=',', index_col=False)

        partial_df.insert(0, 'basisFunction', [basis_function])
        partial_df.insert(0, 'numGroups', [numGroups])
        partial_df.insert(0, 'numProcsPerGroup',[numProcsPerGroup])
        ic(partial_df)

        # validate with total number of processes and then remove the column
        assert(partial_df['numRanks'][0] == numProcsPerGroup * numGroups)

        # append to existing dataframe
        list_of_dataframes.append(partial_df)

    timings_df = pd.concat(list_of_dataframes)
    timings_df.sort_values(by=['numGroups','numProcsPerGroup','basisFunction'], ignore_index=True, inplace=True)
    # save to csv file
    ic(args.output_csv)
    timings_df.to_csv(args.output_csv, index=False)    
    
    ## execute latexmk to generate a pdf plot of the data
    #subprocess.call(["latexmk", "-pdf", "scalingplot.tex"])

