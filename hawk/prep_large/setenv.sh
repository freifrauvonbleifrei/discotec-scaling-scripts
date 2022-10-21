
module load hlrs-software-stack/previous
module load python/3.8 # for scons
module load boost/1.70.0 # for boost
module load openmpi/4.0.5
#TODO update for new software stack
#module load python/3.10
#module load openmpi/4.1.4
#module load intel/19.1.2

SGPP_DIR=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely/DisCoTec-third-level/
LIB_BOOST_DIR=${BOOST_ROOT}/lib/
LIB_GLPK=$SGPP_DIR/glpk/lib/

export LD_LIBRARY_PATH=$SGPP_DIR/lib/sgpp:$LIB_GLPK:$LIB_BOOST_DIR:$LD_LIBRARY_PATH


# for profiling and tracing with scoreP
#. ./setenv_profile.sh

module list
