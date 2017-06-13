#!/bin/bash
set -x

source "$( dirname "${BASH_SOURCE[0]}" )/common.sh"

# ansible mn -m shell -a "rm -r /dev/shm/*"
rm -r /dev/shm/*

#export GLOG_minloglevel=1

#./build/tools/caffe train --solver=models/bvlc_googlenet/solver_client.prototxt -engine=MKL2017 2>&1 | tee -i ~/intelcaffe/out.log
#./build/tools/caffe train --solver=models/bvlc_googlenet/solver_client.prototxt -engine=MKL2017 2>&1

#mpirun -l -ppn 1 -n 2 ./build/tools/caffe train --solver=models/bvlc_googlenet/solver_client_prepare.prototxt -engine=MKL2017 2>&1
#mpirun -l -ppn 2 -n 2 ./build/tools/caffe train --solver=models/bvlc_googlenet/solver_client.prototxt -engine=MKL2017 --weights multinode_googlenet_iter_10.caffemodel 2>&1

#mpirun -l -ppn 1 -n 2 ./build/tools/caffe train --solver=models/bvlc_googlenet/solver_client.prototxt -engine=MKL2017 2>&1 | tee -i out.log
#mpirun -ppn 1 -n 2 -l ./build/tools/caffe train --solver=models/mkl2017_googlenet_v3/solver_client.prototxt -engine=MKL2017 2>&1 | tee -i out.log
#mpirun -ppn 1 -n 2 -l ./build/tools/caffe train --solver=models/default_googlenet_v2/solver_client.prototxt -engine=MKL2017 2>&1 | tee -i out.log

### GoogleNet v1

#mpirun -l -ppn 1 -n 2 ./build/tools/caffe train --solver=models/bvlc_googlenet/solver_client.prototxt --engine=MKL2017 2>&1 | tee -i out.log
#mpirun -l -ppn 1 -n 2 ./build/tools/caffe train --solver=models/bvlc_googlenet/solver_client.prototxt 2>&1 | tee -i out.log
#mpirun -l -ppn 1 -n 2 ./build/tools/caffe train --solver=models/bvlc_googlenet/solver_client.prototxt 2>&1 | tee -i out.log

#mpirun -l -ppn 1 -n 2 ./build/tools/caffe train --solver=models/bvlc_googlenet/solver_client.prototxt -engine=MKL2017 2>&1
#./build/tools/caffe test --model  models/bvlc_googlenet/train_val_client_lmdb.prototxt --weights multinode_googlenet_91k_iter_80.caffemodel --engine=MKL2017 2>&1

caffe_path=$PWD
caffe_parent_path=$(dirname $caffe_path)
echo $caffe_path
echo $caffe_parent_path

echo $MLSL_PATH
#ansible mn -m synchronize -a "src=$MLSL_PATH dest=$caffe_parent_path"
#ansible mn -m synchronize -a "src=$caffe_path dest=$caffe_parent_path"

mpirun -debug -l -ppn 1 -n $(cat $caffe_path/mpd.hosts | wc -l) -machinefile $caffe_path/mpd.hosts numactl --preferred=0 ./build/tools/caffe train -solver=models/bvlc_googlenet/solver.prototxt -engine=MKL2017 2>&1 | tee -i $caffe_path/out.log
# -trace

#alexnet
# mpirun -l -ppn 1 -n $(cat $caffe_path/mpd.hosts | wc -l) -machinefile $caffe_path/mpd.hosts ./build/tools/caffe train \
#  -solver=models/intel_optimized_models/multinode/alexnet_4nodes/solver.prototxt -engine=MKL2017 2>&1 | tee -i $caffe_path/out.log

### GoogleNet v3
#mpirun -l -ppn 1 -n $(cat ~/dev/intelcaffe/mpd.hosts | wc -l) -machinefile ~/dev/intelcaffe/mpd.hosts ./build/tools/caffe train \
#  -solver=models/mkl2017_googlenet_v3/solver_client.prototxt -engine=MKL2017 2>&1 | tee -i ~/dev/intelcaffe/out.log

### Resnet-50

#mpirun -l -ppn 1 -n 2 ./build/tools/caffe train --solver=models/default_resnet_50/solver_mn.prototxt -engine=MKL2017 2>&1

#mpirun -l -ppn 1 -n $(cat ~/dev/intelcaffe/mpd.hosts | wc -l) -machinefile ~/dev/intelcaffe/mpd.hosts ./build/tools/caffe train \
#  -solver=models/default_resnet_50/solver_client.prototxt -engine=MKL2017 2>&1 | tee -i ~/dev/intelcaffe/out.log

### SSD
#./build/tools/caffe train -solver examples/ssd/VGGNet/VOC0712/SSD_300x300/solver.prototxt -weights examples/ssd/VGGNet/VGG_ILSVRC_16_layers_fc_reduced.caffemodel
#mpirun -l -ppn 1 -n 2 ./build/tools/caffe train --solver=examples/ssd/VGGNet/VOC0712/SSD_300x300/solver.prototxt -weights examples/ssd/VGGNet/VGG_ILSVRC_16_layers_fc_reduced.caffemodel 2>&1 | tee -i out.log
