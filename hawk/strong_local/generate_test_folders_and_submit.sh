#!/bin/bash

SGPP_DIR=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-test/DisCoTec/
EXECUTABLE=${SGPP_DIR}/distributedcombigrid/examples/distributed_third_level/combi_example
NNODESSYSTEM=128
WALLTIME="00:40:00"

paramfile="ctparam"
# allows to read the parameter file from the arguments.
# Useful for testing the third level combination on a single system
if [ $# -ge 1 ] ; then
   paramfile=$1
fi

ncombi=1

runfile="run.sh"


for i in {1..8}; do # number of process groups (up to 2^8 / 256) 
	s=5 # process group size is 32
	TWO_TO_I=$((2 ** i))
	TWO_TO_S=$((2 ** s))
	echo $TWO_TO_I
	FOLDER=taskassignment_strong_$TWO_TO_I
	mkdir $FOLDER

	# executable symlink to new directory
	cd $FOLDER
	ln -s $EXECUTABLE
	ln -s ../xthi
	cd -

	# copy parameter file to new directory
	cp $paramfile $FOLDER
	# replace resolutions and parallelizations
	cd $FOLDER
	
	ADD_ARRAY=(0 0 0 0 0 0)
	#TODO this works only for weak scaling
	lmin=(2 2 2 2 2 1)
        lmax=(7 7 7 7 7 6)
	#lmin=(3 3 3 3 3 3)
        #lmax=(8 8 8 8 8 8)
        p=(1 1 1 1 1 1)

	for (( j=0; j<$s; j++ )) do
		# echo ADD_ARRAY ${ADD_ARRAY[@]}
		k=$(( 5 - ($j  % 6) ))
		ADD_ARRAY[$k]=$((ADD_ARRAY[$k] + 1))
		lmin[$k]=$((lmin[$k] + 1))
		lmax[$k]=$((lmax[$k] + 1))
		p[$k]=$((p[$k] * 2))
	done
	echo ADD_ARRAY ${ADD_ARRAY[@]}

	lmin=${lmin[@]}
	lmax=${lmax[@]}
	leval=(3 3 3 3 3 3)
	leval=${leval[@]}
	p=${p[@]}
	ngroup=$TWO_TO_I
	nprocs=$TWO_TO_S

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
	echo "submit $TWO_TO_I"
	qsub $runfile
	
	cd -
done
