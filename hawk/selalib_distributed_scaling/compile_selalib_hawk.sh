


module load python/3.8
module switch mpt/2.23 openmpi/4.0.5
module load boost/1.70.0

module load blis
module load fftw/3.3.8
module load hdf5/1.10.5

module list

cd /lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely/selalib-build/ 

cmake -DCMAKE_BUILD_TYPE=Release -DOPENMP_ENABLED=ON -DHDF5_PARALLEL_ENABLED=ON -DHDF5_INCLUDE_DIR_FORTRAN=/opt/hlrs/spack/rev-004_2020-06-17/hdf5/1.10.5-gcc-9.2.0-fsds2dq4/include/static/ -DLAPACK_LIBRARIES=/opt/hlrs/spack/rev-004_2020-06-17/blis/2.1-gcc-9.2.0-bpa5oqxe/lib/libblis.a -DBLAS_LIBRARIES=/opt/hlrs/spack/rev-004_2020-06-17/blis/2.1-gcc-9.2.0-bpa5oqxe/lib/libblis.a ../selalib

make sll_m_sim_bsl_vp_3d3v_cart_dd_slim_movingB_interface
