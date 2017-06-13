#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/common.sh"

#rm -rf build
#mkdir build
#cd build
#CXX=mpicxx cmake .. -DBLAS=mkl -DUSE_MPI=1 -DCPU_ONLY=1
#export CXXFLAGS=-Iusr/local/include
#export LDFLAGS=-Lusr/local/lib
#CXX=mpiicpc cmake .. -DBLAS=mkl -DUSE_LMSL=1 -DCPU_ONLY=1
#cd ..
#make -C build -j

#make clean
make all -j 18 CAFFE_PER_ITER_TIMINGS=1
