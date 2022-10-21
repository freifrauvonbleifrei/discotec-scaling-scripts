#!/bin/bash

#PBS -N 
#PBS -l select=
#PBS -l walltime=
##PBS -q test

# Change to the direcotry that the job was submitted from
cd $PBS_O_WORKDIR

. ../setenv.sh

paramfile="ctparam"
# allows to read the parameter file from the arguments.
# Useful for testing the third level combination on a single system
if [ $# -ge 1 ] ; then
   paramfile=$1
fi

ngroup=$(grep ngroup $paramfile | awk -F"=" '{print $2}')
nprocs=$(grep nprocs $paramfile | awk -F"=" '{print $2}')

mpiprocs=$((ngroup*nprocs+1))

# General
# for openmpi
mpirun -n "$mpiprocs" --bind-to core --map-by core ./combi_example $paramfile

