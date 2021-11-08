#!/bin/bash
#make
. ./setenv.sh
export PYTHONPATH=/lustre/hpe/ws10/ws10.1/ws/ipvpolli-widely/gene_python_interface_clean/src_python3:$PYTHONPATH
cp ginstance/l_* template/
rm -r ginstance*
rm out/*
python3 preproc.py
cd ginstance
echo "offset 0" > offset.txt
cd ..
