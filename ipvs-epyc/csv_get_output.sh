#!/bin/bash

for i in {0..7}; do # consider doing {0..14} -> up to 16384 procs/PG
	TWO_TO_I=$((2 ** i))
	#echo $TWO_TO_I
	FOLDER=strong_singlegrid__$TWO_TO_I
	LINE=$(head -n 2 $FOLDER/*out | tail -n 1)
	#echo $LINE
	# cf. https://riptutorial.com/bash/example/19469/regex-matching
	#pat=':.*'
	#[[ $LINE =~ $pat ]] # $pat must be unquoted
	#RESULT="${BASH_REMATCH[0]}"
	RESULT=$(cut -d : -f 2 <<< $LINE)
	echo $RESULT
done
