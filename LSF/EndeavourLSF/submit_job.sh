#!/bin/bash

if [ $# -lt 1 ]; then 
    echo "$0 node_number [microarch]"
    exit 1
fi

N=$1

microarch=bdw
if [ $# -gt 1 ]; then
    microarch=$2
fi

if [ "$microarch" == "bdw" ];
then
    queue=workq
    arch=bdwx
elif [ "$microarch" == "knl" ];
then
    queue=inteldevq
    arch=knlb1 #ekf
elif [ "$microarch" == "skl" ]; then
    queue=multigenq #inteldevq
    arch=skl # epb
else
    echo "Invalid microarchitecture: $microarch"
    exit 1
fi

echo "microarch: $microarch"
echo "queue: $queue"
echo "arch: $arch"

caffe_path=$PWD
echo "caffe path: $caffe_path"
topo=googlenet
if [ $# -gt 2 ]; then
    topo=$3
fi
echo "topology: $topo"
timeout=4:00
echo "timeout: $timeout"

topo_short="$(echo $topo | head -c 1)"
bsub -W $timeout -n $N -J $topo_short$microarch$N -q $queue -o "$topo"_"$microarch"_$N.out -e "$topo"_"$microarch"_$N.err -R "{select[$arch] span[ptile=1]}" "sh run_endv.script $N $caffe_path $microarch $topo"
