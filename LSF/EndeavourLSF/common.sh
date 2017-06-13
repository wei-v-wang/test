#!/bin/bash

# Intel compilers
source /opt/intel/compiler/latest/bin/compilervars.sh intel64

# MKL
#source /panfs/users/fzou1/usr/mklbeta/mkl_nightly_2017u2_20161209_lnx/mkl/bin/mklvars.sh intel64
export MKLROOT=/panfs/users/fzou1/usr/mklbeta/mklml_lnx_2017.0.2.20170110

# MLSL
#source /panfs/users/fzou1/usr/mlsl/mlsl_2017.0.006/intel64/bin/mlslvars.sh
source /panfs/users/fzou1/usr/mlsl/ml-dlmsl/_install/intel64/bin/mlslvars.sh

# MPI
#source /opt/intel/impi/latest/impi/2017.1.132/bin64/mpivars.sh

# Caffe deps
export PATH=$PATH:/panfs/users/fzou1/usr/bin
export C_INCLUDE_PATH=$C_INCLUDE_PATH:/panfs/users/fzou1/usr/include:/panfs/users/fzou1/usr/include/mpich-x86_64/
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/panfs/users/fzou1/usr/include:/panfs/users/fzou1/usr/include/mpich-x86_64/

export LIBRARY_PATH=$LIBRARY_PATH:/panfs/users/fzou1/usr/lib64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/panfs/users/fzou1/usr/lib64
