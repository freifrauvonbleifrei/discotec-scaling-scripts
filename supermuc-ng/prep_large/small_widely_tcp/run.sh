#!/bin/bash
# Job Name and Files (also --job-name)
#SBATCH -J small_widely_tcp_with_broker 
#Output and error (also --output, --error):
#SBATCH -o ./%x.%j.out
#SBATCH -e ./%x.%j.err
#Initial working directory (also --chdir):
#SBATCH -D ./
#Notification and type
##SBATCH --mail-type=END
##SBATCH --mail-user=insert_your_email_here
# Wall clock limit:
##SBATCH --time=06:00:00
#SBATCH --time=00:30:00
#SBATCH --no-requeue
#SBATCH --partition=test
#Setup of execution environment
#SBATCH --export=NONE 
#SBATCH --account=pn34mi

#Number of nodes and MPI tasks per node:
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=48

##fixed frequency, no dynamic adjustment
#SBATCH --ear=off
#optional: keep job within one island
#SBATCH --switches=1

. ./setenv.sh

paramfile="ctparam_tiny_tl_system0"
# allows to read the parameter file from the arguments.
# Useful for testing the third level combination on a single system
if [ $# -ge 1 ] ; then
   paramfile=$1
fi

ngroup=$(grep ngroup $paramfile | awk -F"=" '{print $2}')
nprocs=$(grep nprocs $paramfile | awk -F"=" '{print $2}')

mpiprocs=$((ngroup*nprocs+1))


# General
mpiexec -n "$mpiprocs" ./combi_example $paramfile : -n 1 ./thirdLevelManager broker.ini

