module load python/3.8
module switch mpt/2.23 openmpi/4.0.5
module load boost/1.70.0

module load fftw/3.3.8
module load hdf5/1.10.5

# for profiling and tracing with scoreP
#. ./setenv_profile.sh

module list


SGPP_DIR=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely/DisCoTec-selalib/
LIB_GLPK=$SGPP_DIR/glpk/lib/

export LD_LIBRARY_PATH=$SGPP_DIR/lib/sgpp:$LIB_GLPK:$LIB_BOOST_DIR:$LD_LIBRARY_PATH

