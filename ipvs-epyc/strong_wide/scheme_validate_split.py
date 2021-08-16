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
    new = json.load(open(filePath1)) + json.load(open(filePath2))
    print(len(ref), len(new))
    assert (ref == new)