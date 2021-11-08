#!/bin/bash

#PBS -N disco-gene
#PBS -l select=65:node_type=rome:mpiprocs=128
#PBS -l walltime=00:20:00
##PBS -l queue=test


SGPP_DIR=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely/DisCoTec-GENE/
LIB_BOOST_DIR=
LIB_GLPK=$SGPP_DIR/glpk/lib/

export LD_LIBRARY_PATH=$SGPP_DIR/lib/sgpp:$LIB_GLPK:$LIB_BOOST_DIR:$LD_LIBRARY_PATH

# Change to the direcotry that the job was submitted from
cd $PBS_O_WORKDIR

. ./setenv.sh

cd ginstance
echo "offset 0" > offset.txt
source start.bat
cd ..
