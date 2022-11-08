. ./setenv.sh

scons -c && rm -r .scon*

scons -j 8 ISGENE=0 VERBOSE=1 COMPILE_BOOST_TESTS=1 RUN_BOOST_TESTS=0 RUN_CPPLINT=0 BUILD_STATICLIB=0 CC=mpicc FC= CXX=mpicxx OPT=1 TIMING=1 UNIFORMDECOMPOSITION=1 ENABLEFT=0 BOOST_INCLUDE_PATH=${BOOST_ROOT}/include BOOST_LIBRARY_PATH=${BOOST_ROOT}/lib ARCH=avx512 CPPFLAGS=-std=c++17,-xhost,-xCORE-AVX512,-qopt-zmm-usage=high,-qopt-report=5 LINKFLAGS=-qopt-report=5 #,-ipo ##before this comment symbol, the flags were once sensible for production # ,-g,-trace,-tcollect,-c,-O3,-fno_alias,-ipo  # -pg -std=c++14,-g,-trace,-c #DEBUG_OUTPUT=1

#scons -j 8 ISGENE=0 VERBOSE=1 COMPILE_BOOST_TESTS=1 RUN_BOOST_TESTS=0 RUN_CPPLINT=0 BUILD_STATICLIB=0 CC=mpicc FC= CXX=mpiCC OPT=1 TIMING=1 UNIFORMDECOMPOSITION=1 ENABLEFT=0 BOOST_INCLUDE_PATH=${BOOST_ROOT}/include BOOST_LIBRARY_PATH=${BOOST_ROOT}/lib ARCH=avx512 CPPFLAGS=-std=c++17,-march=native #,-ipo LINKFLAGS=-ipo ##before this comment symbol, the flags were once sensible for production # ,-g,-trace,-tcollect,-c,-O3,-fno_alias,-ipo  # -pg -std=c++14,-g,-trace,-c #DEBUG_OUTPUT=1

export LD_LIBRARY_PATH=$(pwd)/lib/sgpp:$(pwd)/glpk/lib:$LD_LIBRARY_PATH

cd distributedcombigrid/third_level_manager/
export LD_LIBRARY_PATH=/dss/lrzsys/sys/spack/release/22.2.1/opt/skylake_avx512/boost/1.75.0-intel-6a2uo5l/lib:$LD_LIBRARY_PATH
make
cd -

cd distributedcombigrid/examples/distributed_third_level/
make clean 
make
cd -

