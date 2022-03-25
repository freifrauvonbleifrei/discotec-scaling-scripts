#!/bin/bash

#PBS -N pinning
#PBS -l select=2:node_type=rome:mpiprocs=128
#PBS -l walltime=00:40:00


# Change to the direcotry that the job was submitted from
cd $PBS_O_WORKDIR

. ../selalib_setenv.sh

paramfile="ctparam"
# allows to read the parameter file from the arguments.
# Useful for testing the third level combination on a single system
if [ $# -ge 1 ] ; then
   paramfile=$1
fi

ngroup=$(grep ngroup $paramfile | awk -F"=" '{print $2}')
nprocs=$(grep nprocs $paramfile | awk -F"=" '{print $2}')

mpiprocs=$((ngroup*nprocs+1))

mpirun -n "$mpiprocs" --report-bindings --bind-to core --map-by core ./selalib_distributed
