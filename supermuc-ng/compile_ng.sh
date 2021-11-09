. ./setenv.sh

scons -j 8 ISGENE=0 VERBOSE=1 COMPILE_BOOST_TESTS=1 RUN_BOOST_TESTS=0 RUN_CPPLINT=0 BUILD_STATICLIB=0 CC=mpicc FC= CXX=mpiCC OPT=1 TIMING=1 UNIFORMDECOMPOSITION=1 ENABLEFT=0 BOOST_INCLUDE_PATH=${BOOST_ROOT}/include BOOST_LIBRARY_PATH=${BOOST_ROOT}/lib ARCH=avx512 CPPFLAGS=-std=c++14,-xhost,-xCORE-AVX512,-qopt-zmm-usage=high,-ipo LINKFLAGS=-ipo #,-g,-trace,-tcollect,-c,-O3,-fno_alias,-ipo  # -pg -std=c++14,-g,-trace,-c #DEBUG_OUTPUT=1

export LD_LIBRARY_PATH=$(pwd)/lib/sgpp:$(pwd)/glpk/lib:$LD_LIBRARY_PATH

#cd distributedcombigrid/third_level_manager/
#make
#cd -

cd distributedcombigrid/examples/distributed_third_level/
make clean 
make
cd -

