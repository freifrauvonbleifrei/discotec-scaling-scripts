#!/bin/bash

#PBS -N weak
#PBS -l select=2:node_type=rome:mpiprocs=128
#PBS -l walltime=00:20:00


SGPP_DIR=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-test/DisCoTec/
LIB_BOOST_DIR=
LIB_GLPK=$SGPP_DIR/glpk/lib/

export LD_LIBRARY_PATH=$SGPP_DIR/lib/sgpp:$LIB_GLPK:$LIB_BOOST_DIR:$LD_LIBRARY_PATH

module load boost/1.70.0 # for boost

# Change to the direcotry that the job was submitted from
cd $PBS_O_WORKDIR

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
mpirun -n "$mpiprocs" omplace -vv -ht spread -c 0-127:bs=128+st=128 ./combi_example $paramfile
# Use for debugging
#mpirun -n "$mpiprocs" xterm -hold -e gdb -ex run --args ./combi_example $paramfile

