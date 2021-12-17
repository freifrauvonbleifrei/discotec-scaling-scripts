
source ./setenv.sh

module load python/3.8 # for scons
#module load impi/19.1.2 # unnecessary -- mpt/2.23 loaded implicitly # for compiler
module load boost/1.70.0 # for boost

scons -j 64 ISGENE=1 VERBOSE=1 BOOST_INCLUDE_PATH=${BOOST_ROOT}/include BOOST_LIBRARY_PATH=${BOOST_ROOT}/lib COMPILE_BOOST_TESTS=1 RUN_BOOST_TESTS=1 RUN_CPPLINT=0 BUILD_STATICLIB=0 CC=mpicc FC=mpifort CXX=mpicxx OPT=1 TIMING=1 UNIFORMDECOMPOSITION=1 ENABLEFT=0 ARCH=avx2 CPPFLAGS=-march=native,-O3 LINKFLAGS=-march=native,-O3  #DEBUG_OUTPUT=1

export LD_LIBRARY_PATH=$(pwd)/lib/sgpp:$(pwd)/glpk/lib:$LD_LIBRARY_PATH

cd distributedcombigrid/third_level_manager/
make
cd -

cd distributedcombigrid/examples/distributed_third_level/
make clean 
make
cd -

cd gene-non-linear
./compile.sh
cd -

cd distributedcombigrid/examples/gene_distributed/
make clean
make -j 64
cd -


#mpiexec.mpich -np 9 ./distributedcombigrid/tests/test_distributedcombigrid_boost --run_test=ftolerance
#mpiexec.mpich -np 9 ./distributedcombigrid/tests/test_distributedcombigrid_boost --run_test=fullgrid
#mpiexec.mpich -np 9 ./distributedcombigrid/tests/test_distributedcombigrid_boost --run_test=hierarchization
#mpiexec.mpich -np 9 ./distributedcombigrid/tests/test_distributedcombigrid_boost --run_test=loadmodel
#mpiexec.mpich -np 9 ./distributedcombigrid/tests/test_distributedcombigrid_boost --run_test=reduce
#mpiexec.mpich -np 9 ./distributedcombigrid/tests/test_distributedcombigrid_boost --run_test=rescheduling
#mpiexec.mpich -np 9 ./distributedcombigrid/tests/test_distributedcombigrid_boost --run_test=stats
#mpiexec.mpich -np 9 ./distributedcombigrid/tests/test_distributedcombigrid_boost --run_test=task
#mpiexec.mpich -np 9 ./distributedcombigrid/tests/test_distributedcombigrid_boost --run_test=distributedfullgrid
#mpiexec.mpich -np 9 ./distributedcombigrid/tests/test_distributedcombigrid_boost --run_test=integration
