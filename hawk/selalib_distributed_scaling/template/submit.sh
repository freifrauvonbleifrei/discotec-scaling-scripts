#!/bin/bash
# Job Name and Files (also --job-name)
#SBATCH -J bsl_3_
#Output and error (also --output, --error):
#SBATCH -o ./%x.%j.out
#SBATCH -e ./%x.%j.err
#Initial working directory (also --chdir):
#SBATCH -D ./
#Notification and type
#SBATCH --mail-type=END
#SBATCH --mail-user=pollinta@ipvs.uni-stuttgart.de
# Wall clock limit:
#SBATCH --time=120:00:00
#SBATCH --no-requeue

#SBATCH --ntasks=65

. ./selalib_setenv.sh

mpiexec.openmpi -n $SLURM_NTASKS ./selalib_distributed

