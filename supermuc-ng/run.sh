#!/bin/bash

#PBS -N weak
#PBS -l select=2:node_type=rome:mpiprocs=128
#PBS -l walltime=00:02:00


# Job Name and Files (also --job-name)
#SBATCH -J weak
#Output and error (also --output, --error):
#SBATCH -o ./%x.%j.out
#SBATCH -e ./%x.%j.err
#Initial working directory (also --chdir):
#SBATCH -D ./
#Notification and type
##SBATCH --mail-type=END
##SBATCH --mail-user=insert_your_email_here
# Wall clock limit:
#SBATCH --time=24:00:00
#SBATCH --no-requeue
#SBATCH --partition=test
#Setup of execution environment
#SBATCH --export=NONE 
#SBATCH --account=pn34mi

#Number of nodes and MPI tasks per node:
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=48 


#Important
module load slurm_setup

SGPP_DIR=/hppfs/work/pn34mi/di39qun2/DisCoTec-third-level/
LIB_BOOST_DIR=
LIB_GLPK=$SGPP_DIR/glpk/lib/

export LD_LIBRARY_PATH=$SGPP_DIR/lib/sgpp:$LIB_GLPK:$LIB_BOOST_DIR:$LD_LIBRARY_PATH
module load boost/1.70.0-intel19-impi
# for boost

# Change to the direcotry that the job was submitted from
# cd $PBS_O_WORKDIR

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
#mpirun -n "$mpiprocs" omplace -v -ht spread -c 0-127:bs=128+st=128 ./xthi
mpirun -l -n "$mpiprocs" --cpu_bind=verbose,rank -m plane=48  -K ./combi_example $paramfile
# Use for debugging
#mpirun -n "$mpiprocs" xterm -hold -e gdb -ex run --args ./combi_example $paramfile

