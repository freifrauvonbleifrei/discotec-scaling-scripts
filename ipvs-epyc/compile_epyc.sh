#!/bin/bash
export LD_LIBRARY_PATH=$(pwd)/lib/sgpp:$(pwd)/glpk/lib:$LD_LIBRARY_PATH

. /home/pollinta/epyc/spack/share/spack/setup-env.sh
spack load boost@1.74.0
# spack load mpich@3.3.1


#scons -c && rm -r .scon*

#scons -j 18 ISGENE=0 VERBOSE=1 COMPILE_BOOST_TESTS=1 RUN_BOOST_TESTS=0 RUN_CPPLINT=0 BUILD_STATICLIB=0 CC=mpicc.openmpi FC= CXX=mpicxx.openmpi TIMING=1 UNIFORMDECOMPOSITION=1 ENABLEFT=0 DEBUG_OUTPUT=0 DOC=0 CPPFLAGS=-g
scons -j 18 ISGENE=0 VERBOSE=1 BOOST_INCLUDE_PATH=/home/pollinta/epyc/spack/opt/spack/linux-ubuntu20.04-zen2/gcc-9.3.0/boost-1.74.0-njx4jlvy2ha6moin64psr6kjakjzt2y5/include BOOST_LIBRARY_PATH=/home/pollinta/epyc/spack/opt/spack/linux-ubuntu20.04-zen2/gcc-9.3.0/boost-1.74.0-njx4jlvy2ha6moin64psr6kjakjzt2y5/lib COMPILE_BOOST_TESTS=1 RUN_BOOST_TESTS=0 RUN_CPPLINT=0 BUILD_STATICLIB=0 CC=mpicc.openmpi FC=mpif90.openmpi CXX=mpicxx.openmpi TIMING=1 UNIFORMDECOMPOSITION=1 ENABLEFT=0 DEBUG_OUTPUT=0 DOC=0 CPPFLAGS=-g
#scons -j 18 ISGENE=0 VERBOSE=1 BOOST_INCLUDE_PATH=/home/pollinta/epyc/spack/opt/spack/linux-ubuntu20.04-zen2/gcc-9.3.0/boost-1.74.0-njx4jlvy2ha6moin64psr6kjakjzt2y5/include BOOST_LIBRARY_PATH=/home/pollinta/epyc/spack/opt/spack/linux-ubuntu20.04-zen2/gcc-9.3.0/boost-1.74.0-njx4jlvy2ha6moin64psr6kjakjzt2y5/lib COMPILE_BOOST_TESTS=1 RUN_BOOST_TESTS=1 RUN_CPPLINT=0 BUILD_STATICLIB=0 CC=/home/pollinta/epyc/spack/opt/spack/linux-ubuntu20.04-zen2/gcc-9.3.0/mpich-3.3.1-mgw56bncesinnm252komgtuj6sz5cya2/bin/mpicc FC= CXX=/home/pollinta/epyc/spack/opt/spack/linux-ubuntu20.04-zen2/gcc-9.3.0/mpich-3.3.1-mgw56bncesinnm252komgtuj6sz5cya2/bin/mpicxx TIMING=1 UNIFORMDECOMPOSITION=1 ENABLEFT=0 DEBUG_OUTPUT=0 DOC=0 CPPFLAGS=-g

cd distributedcombigrid/third_level_manager/
make
cd -

cd distributedcombigrid/examples/distributed_third_level/
make clean 
make
cd -
