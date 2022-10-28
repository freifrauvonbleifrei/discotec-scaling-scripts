#!/bin/bash
# Job Name and Files (also --job-name)
#SBATCH -J 
#Output and error (also --output, --error):
#SBATCH -o ./%x.%j.out
#SBATCH -e ./%x.%j.err
#Initial working directory (also --chdir):
#SBATCH -D ./
#Notification and type
##SBATCH --mail-type=END
##SBATCH --mail-user=insert_your_email_here
# Wall clock limit:
#SBATCH --time=
#SBATCH --no-requeue
#SBATCH --partition=micro
#Setup of execution environment
#SBATCH --export=NONE 
#SBATCH --account=pn34mi

#Number of nodes and MPI tasks per node:
#SBATCH --nodes=
#SBATCH --ntasks-per-node=48

##fixed frequency, no dynamic adjustment
#SBATCH --ear=off
##SBATCH --ear=on
#optional: keep job within one island
#SBATCH --switches=1

. ../../setenv.sh

export ROMIO_HINTS=../../romio_hints

echo "romio hints"
cat $ROMIO_HINTS

paramfile="ctparam"
# allows to read the parameter file from the arguments.
# Useful for testing the third level combination on a single system
if [ $# -ge 1 ] ; then
   paramfile=$1
fi

ngroup=$(grep ngroup $paramfile | awk -F"=" '{print $2}')
nprocs=$(grep nprocs $paramfile | awk -F"=" '{print $2}')

mpiprocs=$((ngroup*nprocs+1))

# thread pinning, cf. 
# https://software.intel.com/content/www/us/en/develop/documentation/mpi-developer-reference-linux/top/environment-variable-reference/process-pinning/environment-variables-for-process-pinning.html
export I_MPI_PIN_PROCESSOR_EXCLUDE_LIST=48-95
#export I_MPI_PIN_PROCESSOR_LIST=0-47
export I_MPI_PIN_PROCESSOR_LIST="allcores"
#"0-47:map=bunch"
export I_MPI_PIN_ORDER=compact

# General
mpiexec -n "$mpiprocs" ./combi_example $paramfile

