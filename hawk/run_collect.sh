#!/bin/bash

#PBS -N collect
#PBS -l select=1:node_type=rome:mpiprocs=128
#PBS -l walltime=00:02:00


SGPP_DIR=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-test/DisCoTec/
LIB_BOOST_DIR=
LIB_GLPK=$SGPP_DIR/glpk/lib/

export LD_LIBRARY_PATH=$SGPP_DIR/lib/sgpp:$LIB_GLPK:$LIB_BOOST_DIR:$LD_LIBRARY_PATH

module load boost/1.70.0 # for boost

# Change to the direcotry that the job was submitted from
cd $PBS_O_WORKDIR

source ../collect_environment.sh
