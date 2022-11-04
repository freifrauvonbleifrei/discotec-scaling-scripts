


# clone the DisCoTec-combischeme-utils
git clone git@github.com:SGpp/DisCoTec-combischeme-utilities.git

cd DisCoTec-combischeme-utilities

for i in {0..6}; do
	ADD_ARRAY=(0 0 0 0 0 0)
	lmin=(1 1 1 1 1 1)
	lmax=(18 18 18 18 18 18)
        p=(3 3 3 3 3 3)

	for (( j=0; j<$i; j++ )) do
		# echo ADD_ARRAY ${ADD_ARRAY[@]}
		k=$(( ($j  % 6) ))
		ADD_ARRAY[$k]=$((ADD_ARRAY[$k] + 1))
		lmin[$k]=$((lmin[$k] + 1))
		lmax[$k]=$((lmax[$k] + 1))
		p[$k]=$((p[$k] * 2))
	done
	#echo ADD_ARRAY ${ADD_ARRAY[@]}

	lmin=${lmin[@]}
	lmax=${lmax[@]}

	python3 create_large_assigned_schemes.py --lmin $lmin --lmax $lmax --num_groups 48 48

	for s in scheme*json; do
		mv ${s} ${i}_${s}
		mv ${i}_${s} ..
	done
done
