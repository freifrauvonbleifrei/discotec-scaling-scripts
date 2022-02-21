module load slurm_setup

SLURM_CPU_BIND=verbose

SGPP_DIR=/hppfs/work/pn34mi/di39qun2/DisCoTec-third-level/
LIB_BOOST_DIR=
LIB_GLPK=$SGPP_DIR/glpk/lib/

export LD_LIBRARY_PATH=$SGPP_DIR/lib/sgpp:$LIB_GLPK:$LIB_BOOST_DIR:$LD_LIBRARY_PATH

module load python/3.8.8-base
#module unload intel-mpi intel-mkl intel
#module load intel-parallel-studio/cluster.2020.2 
module load scons/4.1.0.post1
module load boost/1.70.0-intel19-impi
module list

