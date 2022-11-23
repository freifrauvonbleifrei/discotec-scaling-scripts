#!/bin/bash

SGPP_DIR=/hppfs/work/pn34mi/di39qun2/DisCoTec-third-level-oneboundary/
EXECUTABLE=${SGPP_DIR}/distributedcombigrid/examples/distributed_third_level/combi_example
NNODESSYSTEM=48
WALLTIME="01:40:00"

paramfile="ctparam"
# allows to read the parameter file from the arguments.
# Useful for testing the third level combination on a single system
if [ $# -ge 1 ] ; then
   paramfile=$1
fi

ncombi=12

runfile="run.sh"

for i in {1..5}; do 
        TWO_TO_I=$((2 ** i))
	echo $TWO_TO_I
        FOLDER=strong_64_x_${TWO_TO_I}_group
	
	lmin=(4 4 4 4 8 8)
	lmax=(18 18 18 18 19 19)
        p=(2 2 2 2 2 2)
    	processes_per_group=1
    	for p_k in "${p[@]}"; do
        	((processes_per_group *= p_k))
    	done
	lmin=${lmin[@]}
	lmax=${lmax[@]}
	leval=(3 3 3 3 3 3)
	leval=${leval[@]}
	p=${p[@]}
	ngroup=${TWO_TO_I}
	nprocs=${processes_per_group}

        mkdir $FOLDER

        # executable symlink to new directory
        cd $FOLDER
        ln -s $EXECUTABLE
        cd -

        # copy parameter file to new directory
        cp $paramfile $FOLDER
        # replace resolutions and parallelizations
        cd $FOLDER
        sed -i "s/lmin.*/lmin = $lmin/g" $paramfile
        sed -i "s/lmax.*/lmax = $lmax/g" $paramfile
        sed -i "s/leval.*/leval = $leval/g" $paramfile
        sed -i "s/p =.*/p = $p/g" $paramfile
        sed -i "s/ncombi.*/ncombi = $ncombi/g" $paramfile
        sed -i "s/nprocs.*/nprocs = $nprocs/g" $paramfile
        sed -i "s/ngroup.*/ngroup = $ngroup/g" $paramfile

        ngroup=$(grep ngroup $paramfile | awk -F"=" '{print $2}')
        nprocs=$(grep nprocs $paramfile | awk -F"=" '{print $2}')
        cd -

        #link combination scheme file and use it in parameters
        cd $FOLDER
        for j in ../scheme*.json ; do
                echo scheme $j
                ln -s $j
                scheme_name=$(basename $j)
                sed -i "s/ctscheme.*/ctscheme = ${scheme_name}/g" $paramfile
        done;
        cd -
	
	#replace number of nodes in submit script
	# do not replace number of ranks, we need to have all of the node anyways
	cp $runfile $FOLDER
	cd $FOLDER
	MPIPROCS=$((ngroup*nprocs+1))
	(( NNODES=(MPIPROCS+NNODESSYSTEM-1)/NNODESSYSTEM ))
	
	#PBS -N weak
	#PBS -l select=2:node_type=rome:mpiprocs=128
	#PBS -l walltime=00:02:00
        sed -i "s/#PBS -N .*/#PBS -N $FOLDER/g" $runfile
	sed -i "s/#PBS -l walltime=.*/#PBS -l walltime=$WALLTIME/g" $runfile
	sed -i "s/#PBS -l select=.*/#PBS -l select=$NNODES:node_type=rome:mpiprocs=128/g" $runfile

        #SBATCH --nodes=128
        #SBATCH --time=24:00:00
        sed -i "s/#SBATCH -J .*/#SBATCH -J $FOLDER/g" $runfile
        sed -i "s/#SBATCH --time=.*/#SBATCH --time=$WALLTIME/g" $runfile
        sed -i "s/#SBATCH --nodes=.*/#SBATCH --nodes=$NNODES/g" $runfile
	

	#submit
	echo "created $i $processes_per_group"
	cd -
done
