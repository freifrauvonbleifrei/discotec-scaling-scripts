#!/bin/bash

SGPP_DIR=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely/DisCoTec-GENE/
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

runfile="submit.sh"

for i in {4..4}; do # {4..8}; do #
	TWO_TO_I=$((2 ** i))
	echo $TWO_TO_I
	FOLDER=n5_gene_weak_$TWO_TO_I
	cp -r gene_distributed_template_folder $FOLDER

#	# replace resolutions and parallelizations
	cd $FOLDER
	
	ADD_ARRAY=(0 0 0 0)
	#lmin=(3 5 2 2 2 1)
	lmin=(3 2 3 2)
	#lmax=(8 5 7 7 7 1)
	lmax=(8 7 8 7)
        #p=(1 1 2 2 4 1)
	p=(1 2 2 4)
	lx=31.25

	for (( j=0; j<$(($i - 4)); j++ )) do
		# echo ADD_ARRAY ${ADD_ARRAY[@]}
		# increase right to left
		#k=$(( 3 - ($j  % 4) ))
		# increase left to right
		k=$(($j % 4))
		ADD_ARRAY[$k]=$((ADD_ARRAY[$k] + 1))
		lmin[$k]=$((lmin[$k] + 1))
		lmax[$k]=$((lmax[$k] + 1))
		p[$k]=$((p[$k] * 2))
	done
	echo ADD_ARRAY ${ADD_ARRAY[@]}

	lmin=("${lmin[@]:0:1}" "5" "${lmin[@]:1:3}" "1")
	lmin=${lmin[@]}
	lmax=("${lmax[@]:0:1}" "5" "${lmax[@]:1:3}" "1")
	lmax=${lmax[@]}
	leval=(3 3 3 3 3 3)
	leval=${leval[@]}
	p=("${p[@]:0:1}" "1" "${p[@]:1:3}" "1")
	p=${p[@]}
	two_to_lx=$((2**ADD_ARRAY[0]))
	lx=`echo ${lx} \* ${two_to_lx} |bc` ##$((lx * two_to_lx))
	echo $two_to_lx lx ${lx}
	ngroup=1
	nprocs=$TWO_TO_I

	sed -i "s/lmin.*/lmin = $lmin/g" $paramfile
        sed -i "s/lmax.*/lmax = $lmax/g" $paramfile
        sed -i "s/leval=.*/leval = $leval/g" $paramfile
	sed -i "s/p =.*/p = $p/g" $paramfile
	sed -i "s/lx =.*/lx = $lx/g" $paramfile
	sed -i "s/ncombi.*/ncombi = $ncombi/g" $paramfile
	sed -i "s/nprocs.*/nprocs = $nprocs/g" $paramfile
	sed -i "s/ngroup.*/ngroup = $ngroup/g" $paramfile

	ngroup=$(grep ngroup $paramfile | awk -F"=" '{print $2}')
	nprocs=$(grep nprocs $paramfile | awk -F"=" '{print $2}')
	
	
	#replace number of nodes in submit script
	# do not replace number of ranks, we need to have all of the node anyways
	MPIPROCS=$((ngroup*nprocs+1))
	(( NNODES=(MPIPROCS+NNODESSYSTEM-1)/NNODESSYSTEM ))
	
	#PBS -N weak
	#PBS -l select=2:node_type=rome:mpiprocs=128
	#PBS -l walltime=00:02:00
        sed -i "s/#PBS -N .*/#PBS -N $FOLDER/g" $runfile
	sed -i "s/#PBS -l walltime=.*/#PBS -l walltime=$WALLTIME/g" $runfile
	sed -i "s/#PBS -l select=.*/#PBS -l select=$NNODES:node_type=rome:mpiprocs=128/g" $runfile
	
	# run preprocessing script to generate combination scheme and task folders
	./preproc.sh

	#submit
	echo "submit $TWO_TO_I"
	qsub $runfile
	
	cd -
done
