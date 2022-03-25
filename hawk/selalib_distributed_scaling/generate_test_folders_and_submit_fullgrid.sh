#!/bin/bash

SGPP_DIR=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely/DisCoTec-selalib/
EXECUTABLE=${SGPP_DIR}/distributedcombigrid/examples/selalib_distributed/selalib_distributed
NNODESSYSTEM=128
WALLTIME="00:40:00"

templatefolder="template"
paramfile="ctparam"
# allows to read the parameter file from the arguments.
# Useful for testing the third level combination on a single system
if [ $# -ge 1 ] ; then
   paramfile=$1
fi

ncombi=12

runfile="run.sh"

for i in {8..13}; do # consider doing {8..13} 
	TWO_TO_I=$((2 ** i))
	echo $TWO_TO_I
	FOLDER=strong_${TWO_TO_I}_fg
	cp -r $templatefolder $FOLDER

	# executable symlink to new directory
	cd $FOLDER
	ln -s $EXECUTABLE
	#ln -s ../xthi

	# replace resolutions and parallelizations
	ADD_ARRAY=(0 0 0 0 0 0)
	#TODO this works only for weak scaling
	lmin=(6 6 6 6 6 6)
	lmax=(6 6 6 6 6 6)
        p=(1 1 1 1 1 1)

	for (( j=0; j<$i; j++ )) do
		# echo ADD_ARRAY ${ADD_ARRAY[@]}
		k=$(( 5 - ($j  % 6) ))
		p[$k]=$((p[$k] * 2))
	done
	#echo ADD_ARRAY ${ADD_ARRAY[@]}

	resolution=(64 64 64 64 64 64)
	resolution=${resolution[@]}
	lmin=${lmin[@]}
	lmax=${lmax[@]}
	leval=(3 3 3 3 3 3)
	leval=${leval[@]}
	p=${p[@]}
	ngroup=1
	nprocs=$TWO_TO_I

	sed -i "s/lmin.*/resolution = $resolution \n lmin = $lmin/g" $paramfile
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
