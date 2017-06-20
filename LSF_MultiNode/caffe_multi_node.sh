#!/bin/sh

numprocs=4
CAFFE_WORK_DIR=/tmp/caffe/
arch_=knl
topo=googlenet


# Names to configfile, binary (executable) files #
numnodes=`cat $PBS_NODEFILE | wc -l`
cfile=${CAFFE_WORK_DIR}/nodeconfig-${topo}-${arch_}-${numnodes}.txt
xeonbin="${CAFFE_WORK_DIR}/build/tools/caffe train"
nodenames=( `cat $PBS_NODEFILE | sort | uniq ` )

numservers=4
listep=6,7,8,9
export MLSL_SERVER_AFFINITY="${listep}"

threadspercore=1
ppncpu=1

cores=72
sockets=1
maxcores=72

numthreads=68

# MLSL configuration
export MLSL_LOG_LEVEL=0
export MLSL_NUM_SERVERS=${numservers}
export EPLIB_DYNAMIC_SERVER=process

# PSM2 configuration
export PSM2_MQ_RNDV_HFI_WINDOW=2097152 # to workaround PSM2 bug in IFS 10.2 and 10.3
export PSM2_IDENTIFY=1 # for debug
export HFI_NO_CPUAFFINITY=1

# IMPI configuration
export I_MPI_FABRICS=tmi # tcp
export I_MPI_TMI_PROVIDER=psm2
#export I_MPI_FALLBACK=0
export I_MPI_DYNAMIC_CONNECTION=0
#export I_MPI_SCALABLE_OPTIMIZATION=0
export I_MPI_PIN_MODE=lib
export I_MPI_PIN_DOMAIN=node
export I_MPI_DEBUG=6

# OMP configuration
affinitystr="proclist=[0-5,10-71],granularity=thread,explicit"

echo THREAD SETTINGS: Affinity $affinitystr Threads $numthreads Placement $KMP_PLACE_THREADS


# Produce the configuration file for mpiexec. Each line of the config file contains a # host, environment, binary name.

rm -f $cfile
node_id=1
max_ppn=1
numthreads_per_proc=68
echo numthreads_proc $numthreads_per_proc max_ppn $max_ppn

log_file=outputCluster-${topo}-${arch_}-${numnodes}.txt
lmdb_dirs=(ilsvrc12_train_lmdb ilsvrc12_val_lmdb)

for node in "${nodenames[@]}"
do
	echo "-host ${node} -genv OMP_NUM_THREADS ${numthreads_per_proc} -n $max_ppn numactl --preferred=0 $xeonbin --solver models/intel_optimized_models/googlenet/solver.prototxt -engine=MKL2017" >> $cfile
done 

#./build/tools/caffe train -solver models/intel_optimized_models/alexnet/solver.prototxt  -engine MKL2017
source ~/.bashrc
export CAFFE_ROOT=/tmp/intelcaffe/
export LD_LIBRARY_PATH=/tmp/intelcaffe/external/mkldnn/install/lib:$LD_LIBRARY_PATH
cd /tmp/intelcaffe
source /opt/intel/mlsl_2017.0.014/intel64/bin/mlslvars.sh
time GLOG_minloglevel=0 mpiexec.hydra -l -configfile $cfile 2>&1 |tee outputCluster.txt
