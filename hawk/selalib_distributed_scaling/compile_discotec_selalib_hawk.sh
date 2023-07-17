module load python
module switch mpt openmpi
#module load boost

module load blis
#module show scalapack/2.1.0
module load fftw
#module load hdf5/1.10.5

module list

. /lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely-distributed-ct/spack/share/spack/setup-env.sh
spack load cmake
spack load boost /2limzzu
spack load glpk
spack load hdf5@1.12.2 /zus3dst #+fortran+mpi~share

 mkdir -p build_release
 cd build_release
 cmake -DCMAKE_BUILD_TYPE=Release -DDISCOTEC_OPENMP=1 -DDISCOTEC_USE_LTO=1 -DDISCOTEC_TEST=1 -DDISCOTEC_TIMING=1  -DDISCOTEC_ENABLEFT=0 -DDISCOTEC_GENE=0 -DDISCOTEC_HDF5=0 -DDISCOTEC_USE_HIGHFIVE=0 -DDISCOTEC_WITH_SELALIB=1 -DSELALIB_DIR=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely-distributed-ct/selalib/build_release/package/ ..
 make 
