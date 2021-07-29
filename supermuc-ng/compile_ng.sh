module load boost/1.70.0-intel19-impi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/glpk/lib

../scons/scons.py -j 8 ISGENE=0 VERBOSE=1 COMPILE_BOOST_TESTS=1 RUN_BOOST_TESTS=0 RUN_CPPLINT=0 BUILD_STATICLIB=0 CC=/dss/dsshome1/lrz/sys/intel/impi2019u6/compilers_and_libraries_2020.0.154/linux/mpi/intel64/lrzbin/mpicc FC= CXX=/dss/dsshome1/lrz/sys/intel/impi2019u6/compilers_and_libraries_2020.0.154/linux/mpi/intel64/lrzbin/mpicxx OPT=1 TIMING=0 UNIFORMDECOMPOSITION=1 ENABLEFT=0 BOOST_INCLUDE_PATH=${BOOST_ROOT}/include BOOST_LIBRARY_PATH=${BOOST_ROOT}/lib CPPFLAGS=-std=c++14 #DEBUG_OUTPUT=1

export LD_LIBRARY_PATH=$(pwd)/lib/sgpp:$(pwd)/glpk/lib:$LD_LIBRARY_PATH

cd distributedcombigrid/third_level_manager/
make
cd -

cd distributedcombigrid/examples/distributed_third_level/
make clean 
make
cd -

