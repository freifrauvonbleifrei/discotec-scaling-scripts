module load python
module switch mpt openmpi
module load boost

module load blis
#module load scalapack/2.1.0
#module show scalapack/2.1.0
module load fftw

module list
#output :   1) system/site_names   2) system/ws/1.4.0   3) system/wrappers/1.0   4) hlrs-software-stack/current   5) gcc/10.2.0   6) python/3.10   7) openmpi/4.1.4   8) boost/1.70.0   9) blis/2.1  10) fftw/3.3.8


. /lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely-distributed-ct/spack/share/spack/setup-env.sh
spack load cmake
spack load hdf5@1.12.2 /zus3dst #+fortran+mpi~share

mkdir -p build_release
cd build_release
cmake -DCMAKE_BUILD_TYPE=Release -DOPENMP_ENABLED=ON -DHDF5_PARALLEL_ENABLED=ON -DUSE_FMEMPOOOL=OFF -DCMAKE_INSTALL_PREFIX=$(pwd)/install -DBLAS_LIBRARIES=/sw/hawk-rh8/hlrs/spack/rev-009_2022-09-01/blis/2.1-gcc-10.2.0-g6f3pga5/lib/libblis.a -DLAPACK_LIBRARIES=/sw/hawk-rh8/hlrs/spack/rev-009_2022-09-01/scalapack/2.1.0-clang-12.0.0-3rnbmnz6/lib/libscalapack.a .. 

make test_cpp_interface
make sll_m_sim_bsl_vp_3d3v_cart_dd_slim_interface
make sim_bsl_vp_3d3v_cart_dd_slim
make install # fails due to some lapack linking thing; we don't need it

# hacky finish of "make install"
mkdir -p install/lib
cp package/libselalib.a install/lib
cp simulations/parallel/bsl_vp_3d3v_cart_dd/libsll_m_sim_bsl_vp_3d3v_cart_dd_slim_interface.a install/lib
cp external/fftpack/libdfftpack.a install/lib
cp external/pppack/libpppack.a install/lib
cp external/nufft/libnufft.a install/lib
cp external/burkardt/sobol/libsobol.a install/lib
cp external/burkardt/prob/libprob.a install/lib
cp external/mudpack/libmudpack.a install/lib


