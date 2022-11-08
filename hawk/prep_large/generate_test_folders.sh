#!/bin/bash

SGPP_DIR=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely/DisCoTec-third-level/
EXECUTABLE=${SGPP_DIR}/distributedcombigrid/examples/distributed_third_level/combi_example
NNODESSYSTEM=128
WALLTIME="00:40:00"

paramfile="ctparam"
# allows to read the parameter file from the arguments.
# Useful for testing the third level combination on a single system
if [ $# -ge 1 ] ; then
   paramfile=$1
fi

ncombi=12

runfile="run.sh"

for i in {0..6}; do # consider doing {0..14} -> up to 16384 procs/PG
	echo $i
	FOLDER=${i}_weak_1_group
	mkdir $FOLDER

	# executable symlink to new directory
	cd $FOLDER
	ln -s $EXECUTABLE
	#ln -s ../xthi
	cd -

	# copy parameter file to new directory
	cp $paramfile $FOLDER
	# replace resolutions and parallelizations
	cd $FOLDER
	
	ADD_ARRAY=(0 0 0 0 0 0)
	lmin=(1 1 1 1 1 1)
	lmax=(18 18 18 18 18 18)
        p=(1 3 3 3 3 3)

	for (( j=0; j<$i; j++ )) do
		# echo ADD_ARRAY ${ADD_ARRAY[@]}
		k=$(( ($j  % 6) ))
		ADD_ARRAY[$k]=$((ADD_ARRAY[$k] + 1))
		lmin[$k]=$((lmin[$k] + 1))
		lmax[$k]=$((lmax[$k] + 1))
		p[$k]=$((p[$k] + 2))
	done
	#echo ADD_ARRAY ${ADD_ARRAY[@]}
	#echo p ${p[@]}
    	processes_per_group=1
    	for p_k in "${p[@]}"; do
        	((processes_per_group *= p_k))
    	done
	lmin=${lmin[@]}
	lmax=${lmax[@]}
	leval=(3 3 3 3 3 3)
	leval=${leval[@]}
	p=${p[@]}
	ngroup=1
	nprocs=${processes_per_group}

	sed -i "s/lmin.*/lmin = $lmin/g" $paramfile
        sed -i "s/lmax.*/lmax = $lmax/g" $paramfile
        sed -i "s/leval.*/leval = $leval/g" $paramfile
	sed -i "s/p =.*/p = $p/g" $paramfile
	sed -i "s/ncombi.*/ncombi = $ncombi/g" $paramfile
	sed -i "s/nprocs.*/nprocs = $nprocs/g" $paramfile
	sed -i "s/ngroup.*/ngroup = $ngroup/g" $paramfile

	ngroup=$(grep ngroup $paramfile | awk -F"=" '{print $2}')
	nprocs=$(grep nprocs $paramfile | awk -F"=" '{print $2}')

	#link combination scheme file and use it in parameters
	for j in ../../../twosystem_largest/${i}_*split1_48groups.json ; do
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
	
	##PBS -N weak
	#PBS -l select=2:node_type=rome:mpiprocs=128
	#PBS -l walltime=00:02:00
        sed -i "s/#PBS -N .*/#PBS -N $FOLDER/g" $runfile
	sed -i "s/#PBS -l walltime=.*/#PBS -l walltime=$WALLTIME/g" $runfile
	sed -i "s/#PBS -l select=.*/#PBS -l select=$NNODES:node_type=rome:mpiprocs=128/g" $runfile
	

	#submit
	echo "created $i $processes_per_group"
	cd -
done
