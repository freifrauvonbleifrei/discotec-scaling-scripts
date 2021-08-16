#!/usr/bin/env python3

"""Convert levels (e.g. output from stats) into scheme.json file
"""

import sys
import json


if __name__ == "__main__":
    assert(len(sys.argv) == 3)
    filePath1 = sys.argv[1]
    filePath2 = sys.argv[2]
    refFilePath = "ctscheme_tl_full.json"

    ref = json.load(open(refFilePath))
    new = json.load(open(filePath1))
    new2 = ref.copy()

    for thing in new:
        print(thing)
        # for other_thing in new2:
        for i in reversed(range(len(new2))):
            other_thing=new2[i]
            if thing == other_thing:
                print("del ", new2[i])
                del new2[i]

    print(len(ref), len(new)+len(new2), len(new2))

    #convert python jsonArray to JSON String and write to file
    with open(filePath2, 'w', encoding='utf-8') as jsonf:
        jsonString = json.dumps(new2, indent=4)
        jsonf.write(jsonString)

