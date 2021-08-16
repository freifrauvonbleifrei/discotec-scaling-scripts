#!/usr/bin/env python3

"""Convert levels (e.g. output from stats) into scheme.json file
"""

import sys
import json


if __name__ == "__main__":
    assert(len(sys.argv) == 2)
    filePath = sys.argv[1]
    jsonArray = []

    # cf. https://pythonexamples.org/python-csv-to-json/
    #read csv file
    with open(filePath, encoding='utf-8') as csvf:
        for row in csvf:
            unit = str.split(row, sep=";")
            # print(unit)
            cl = [u.split(sep=":")[-1][:-2] for u in unit]
            cl = list(filter(lambda u: u != "", cl))
            c = [int(u.split(sep="[")[0][1:]) for u in cl]
            l = [u.split(sep="[")[1] for u in cl]
            l = [[int(i) for i in u.split(sep=" ")] for u in l]
            # print(c,l)
            for i in range(len(c)):
                jrow = {"coeff": c[i], "level": l[i]}
                # print(jrow)
                jsonArray.append(jrow)

    jsonFilePath = filePath + ".json"
    #convert python jsonArray to JSON String and write to file
    with open(jsonFilePath, 'w', encoding='utf-8') as jsonf: 
        jsonString = json.dumps(jsonArray, indent=4)
        jsonf.write(jsonString)