#!/bin/bash

#./build/tools/caffe train -solver models/intel_optimized_models/alexnet/solver.prototxt  -engine MKL2017
source ~/.bashrc
export CAFFE_ROOT=/home/wangwei3/shared/intelcaffe/
export LD_LIBRARY_PATH=/home/wangwei3/intelcaffe/external/mkldnn/install/lib:$LD_LIBRARY_PATH
#mpiexec.hydra $CAFFE_ROOT/caffe train --solver $CAFFE_ROOT/models/intel_optimized_models/alexnet/solver.prototxt  --weights models/bvlc_googlenet.caffemodel -engine MKL2017
#mpiexec.hydra $CAFFE_ROOT/build/tools/caffe train --solver $CAFFE_ROOT/models/intel_optimized_models/alexnet/solver.prototxt  -engine MKL2017
cd /home/wangwei3/shared/intelcaffe
export OMP_NUM_THREADS=40
export KMP_AFFINITY=verbose,granularity=fine,proclist=[0-39],explicit
# the following lines work
#mpiexec.hydra ./build/tools/caffe time -model $CAFFE_ROOT/models/intel_optimized_models/alexnet/train_val.prototxt  --iterations 10 -engine MKL2017
source /home/wangwei3/intel/mlsl_2017.0.014/intel64/bin/mlslvars.sh
export I_MPI_HYDRA_BOOTSTRAP=lsf
export I_MPI_HYDRA_BRANCH_COUNT=144
export I_MPI_LSF_USE_COLLECTIVE_LAUNCH=1
#wget http://dl.caffe.berkeleyvision.org/bvlc_alexnet.caffemodel
mpiexec.hydra ./build/tools/caffe train --solver $CAFFE_ROOT/models/intel_optimized_models/alexnet/solver.prototxt --weights $CAFFE_ROOT/bvlc_alexnet.caffemodel -engine MKL2017
