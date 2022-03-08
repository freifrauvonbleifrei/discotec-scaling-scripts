#!/usr/bin/env python3

from tokenize import group
import math
import numpy as np
import itertools as it
from icecream import ic
import pandas as pd
from scipy.special import binom
import json


class ClassicDiagonalActiveSet():
    def __init__(self, lmax, lmin=None, diagonalIndex=0):
        self.lmax = lmax
        if lmin == None:
            self.lmin = [1 for i in range(len(self.lmax))]
        else:
            self.lmin = lmin
        self.diagonalIndex = diagonalIndex

    def getMinLevelSum(self):
        return self.getLevelMinima().sum()

    def getLevelMinima(self):
        maxInd = np.argmax(np.array(self.lmax)-np.array(self.lmin))
        lm = np.array(self.lmin)
        lm[maxInd] = self.lmax[maxInd]
        return lm

    def getActiveSet(self):
        listOfRanges = [list(range(0, self.lmax[i]+1))
                        for i in range(len(self.lmax))]
        listOfAllGrids = list(it.product(*listOfRanges))
        s = set()
        levelSum = self.getMinLevelSum()+self.diagonalIndex
        for grid in listOfAllGrids:
            if (np.sum(grid) == levelSum and (np.array(grid) >= np.array(self.lmin)).all()):
                s.add(grid)

        return s


class combinationSchemeArbitrary():
    def __init__(self, activeSet):
        self.activeSet = activeSet
        self.updateDict()

    def getDownSet(self, l):
        subs = [list(range(0, x + 1)) for x in l]
        downSet = it.product(*subs)
        return downSet

    def getSubspaces(self):
        subspacesSet = set()
        for l in self.dictOfScheme:
            for subspace in self.getDownSet(l):
                subspacesSet.add(subspace)
        return subspacesSet

    def updateDict(self):
        lmin = self.activeSet.lmin
        lmax = self.activeSet.lmax
        firstLevelDifference = lmax[0] - lmin[0]
        dim = len(lmin)
        uniformLevelDifference = [(lmax[i] - lmin[i]) == firstLevelDifference for i in range(dim)]
        if uniformLevelDifference and firstLevelDifference >= dim:
            ic("binomial")
            # can calculate it by binomial formula
            listOfRanges = [list(range(lmin[i], lmax[i]+1))
                            for i in range(len(lmax))]
            self.dictOfScheme = {}
            for q in range(dim):
                coeff = (-1)**q * binom(dim-1, q)
                levelSum = sum(lmin) + firstLevelDifference - q
                # ic(coeff, levelSum)
                for grid in it.product(*listOfRanges):
                    if (np.sum(grid) == levelSum and (np.array(grid) >= np.array(lmin)).all()):
                        self.dictOfScheme[grid] = coeff

        else:
            self.dictOfScheme = {}
            for l in self.activeSet.getActiveSet():
                self.dictOfScheme[l] = 1

            dictOfSubspaces = {}

            for l in self.dictOfScheme:
                for subspace in self.getDownSet(l):
                    if subspace in dictOfSubspaces:
                        dictOfSubspaces[subspace] += 1
                    else:
                        dictOfSubspaces[subspace] = 1

            # # remove subspaces which are too much
            while(set(dictOfSubspaces.values()) != set([1])):

                for subspace in dictOfSubspaces:
                    currentCount = dictOfSubspaces[subspace]
                    if currentCount != 1:
                        diff = currentCount - 1

                        if subspace in self.dictOfScheme:

                            self.dictOfScheme[subspace] -= diff
                            if self.dictOfScheme[subspace] == 0:
                                del self.dictOfScheme[subspace]

                        else:
                            self.dictOfScheme[subspace] = -diff

                        for l in self.getDownSet(subspace):
                            dictOfSubspaces[l] -= diff

    def getCombinationDictionary(self):
        return self.dictOfScheme

def getLevel(index, lmax):
    if index == 0:
        return 0
# cf. https://python-programs.com/python-program-to-find-position-of-rightmost-set-bit/
#def getFirstSetBitPosition(numb):
    # Calculate and the value of log2(n&-n)+1 which gives the first set bit position
    # of the given number and store it in a variable say result_pos.
    result_pos = math.log2(index & -index)
    # Return the value of result_pos(Which is the position of the first set bit).
    return lmax - int(result_pos)

lmin = [1]*6
lmax = [18]*6
lmin = [2]*6
lmax = [19]*6
highestIndexPlusOne = 2**lmax[-1]+1
decomposition1d = [0, 80450, 181695, highestIndexPlusOne] #optimal for 18
decomposition1d = [0, 98304, 196609, 327680, 425985, highestIndexPlusOne]# optimal for 19
#outerSlices = 1#98304 #98306
#betweenSlices = 49121 - outerSlices
#midSlice = highestIndexPlusOne - 2*betweenSlices - 2*outerSlices
#decomposition1d = [0, outerSlices, outerSlices+betweenSlices, highestIndexPlusOne-outerSlices-betweenSlices, highestIndexPlusOne-outerSlices, highestIndexPlusOne]

# results on "big" scenario
# ic| len(scheme.getCombinationDictionary()): 88571
# ic| numGridsOfSize: {24: 6188, 25: 8568, 26: 11628, 27: 15504, 28: 20349, 29: 26334}
# ic| totalNumPointsCombi: 39393796580139
#     totalNumPointsCombi/1e13: 3.9393796580139
# 39393796580139
# ic| 'binomial'
# 763707785217
# ic| mem_total: 306377444.19369507
#     mem_sg/mem_total: 0.019017809928344377

#lmin = [2]*2 # for testing
#lmax = [5]*2
#decomposition1d = [0,6,12,19,25,33]
activeSet = ClassicDiagonalActiveSet(lmax, lmin)
# scheme = active set und Koeffizienten dazu
scheme = combinationSchemeArbitrary(activeSet)

numGridsOfSize = {}
numPointsCombiPerLevelOfFirstDim = [0]*(lmax[0]+1)

totalNumPointsCombi = 0
for key, value in scheme.getCombinationDictionary().items():
    totalNumPointsCombi += np.prod([2**l + 1 for l in key])
    levelSum=np.sum([l for l in key])
    if levelSum in numGridsOfSize:
        numGridsOfSize[levelSum] += 1
    else:
        numGridsOfSize[levelSum] = 1
    pointsInDimHigher = np.prod([2**l + 1 for l in key[1:]])
    # ic(key, pointsInDimHigher)
    for d in range(key[0] + 1):
        numPointsCombiPerLevelOfFirstDim[d] += pointsInDimHigher

numPointsCombiPerIndexOfFirstDim = [numPointsCombiPerLevelOfFirstDim[getLevel(
    index, lmax[0])] for index in range(2**lmax[0] + 1)]
# ic(numPointsCombiPerIndexOfFirstDim)
df = pd.DataFrame(numPointsCombiPerIndexOfFirstDim)
df.to_csv("numPointsCombiPerIndexOfFirstDim.csv")

partsDecompositionCombi = [np.sum(numPointsCombiPerIndexOfFirstDim[decomposition1d[i]                                                      :decomposition1d[i+1]]) for i in range(len(decomposition1d) - 1)]
ic(decomposition1d, numPointsCombiPerLevelOfFirstDim, partsDecompositionCombi)
fractionsDecompositionCombi = [(part/totalNumPointsCombi)**len(lmax) for part in partsDecompositionCombi]
ic(fractionsDecompositionCombi)

ic(len(scheme.getCombinationDictionary()))
ic(numGridsOfSize)
ic(totalNumPointsCombi, totalNumPointsCombi/1e13)
print(totalNumPointsCombi)
# mem = (totalNumPointsCombi*8)*4 # worst case memory requirement of full grids in scheme in bytes
mem = (totalNumPointsCombi*8) # minimum memory requirement of full grids in scheme in bytes
mem = mem/(2**20) # memory requirement of full scheme in Mebibytes

evenIndex=0
sumFirst=0
sumSecond=0
ic(totalNumPointsCombi,totalNumPointsCombi/(len(decomposition1d) - 1.),len(decomposition1d) - 1.)
while sumFirst < totalNumPointsCombi/(len(decomposition1d) - 1.):
    sumFirst += numPointsCombiPerIndexOfFirstDim[evenIndex]
    evenIndex +=1
secondIndex=evenIndex
sumSecond=sumFirst
while sumSecond < 2.*totalNumPointsCombi/(len(decomposition1d) - 1.):
    sumSecond += numPointsCombiPerIndexOfFirstDim[secondIndex]
    secondIndex +=1
ic(evenIndex,secondIndex)

totalNumPointsSparse = 0
numPointsSGPerLevelOfFirstDim = [0]*(lmax[0]+1)
# use optimized sparse grid, with lmax 1 lower in each dim
optimizedSG = True
if optimizedSG:
    reduced_lmax = [max(lmax[d] - 1, lmin[d]) for d in range(len(lmax))]
    activeSetSparse = ClassicDiagonalActiveSet(reduced_lmax, lmin)
    schemeSparse = combinationSchemeArbitrary(activeSetSparse)
else:
    reduced_lmax = lmax
    schemeSparse = scheme

for key in schemeSparse.getSubspaces():
    # ic(key)
    totalNumPointsSparse += np.prod([2**(l-1) if l > 0 else 2 for l in key])
    pointsInDimHigher = np.prod([2**(l-1) if l > 0 else 2 for l in key[1:]])
    # ic(key, pointsInDimHigher)
    numPointsSGPerLevelOfFirstDim[key[0]] += pointsInDimHigher

numPointsSGPerIndexOfFirstDim = [numPointsSGPerLevelOfFirstDim[getLevel(
    index, lmax[0])] for index in range(2**lmax[0] + 1)]
ic(decomposition1d, numPointsSGPerLevelOfFirstDim)

partsDecompositionSG = [np.sum(numPointsSGPerIndexOfFirstDim[decomposition1d[i]                                                      :decomposition1d[i+1]]) for i in range(len(decomposition1d) - 1)]
assert(np.sum(partsDecompositionSG) == totalNumPointsSparse)
ic(partsDecompositionSG)
# for decomposition1d = [0, 104858, 209716, 314573, 419431, 2**19+1]
# ic| partsDecompositionSG: [160383280349, 151701508737, 139538207045, 151701508737, 160383280349]
# ic| fractionsDecompositionSG: [8.578102765038981e-05,
#                                6.142937454031834e-05,
#                                3.7204504355638963e-05,
#                                6.142937454031834e-05,
#                                8.578102765038981e-05]

# will get the largest and smallest fractions of the DOF for len(lmax) dimensions of the same decomposition
fractionsDecompositionSG = [(part/totalNumPointsSparse)**len(lmax) for part in partsDecompositionSG]
ic(fractionsDecompositionSG)
print(totalNumPointsSparse)
mem_sg = (totalNumPointsSparse*8)
mem_sg = mem_sg/(2**20) # memory requirement of sparse grid in Mebibytes

mem_total = mem_sg+mem
ic(mem_total, mem_sg/mem_total)

numProcessGroups = 65
# numProcessGroups = 3
assignment = { i : {} for i in range(numProcessGroups)}
assignedFGSize = [0.]*numProcessGroups
roundRobinIndex = 0
for size in numGridsOfSize:
    # ic(size)
    for key, value in scheme.getCombinationDictionary().items():
        levelSum=np.sum([l for l in key])
        if levelSum == size:
            # ic(key, value)
            assignment[roundRobinIndex][key] = value
            roundRobinIndex = (roundRobinIndex+1)%numProcessGroups
            assignedFGSize[roundRobinIndex] += 2**levelSum
ic(assignedFGSize)

schemeList = []
for group_no in assignment.keys():
    # ic(assignment[group_no])
    schemeList += [{"coeff": coeff, "level": list(level), "group_no": group_no}
              for level, coeff in assignment[group_no].items()]

# ic(schemeList)
jsonString = json.dumps(schemeList)

with open('scheme.json', 'w') as f:
    f.write(jsonString)
