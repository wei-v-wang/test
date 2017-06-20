#!/bin/bash

N=4
JOBID=1
bsub -W 0:20 -n $N -J knl$N-$JOBID -q inteldevq -o knl_$N-$JOBID.out -e knl_$N-$JOBID.err -R "4*{select[ekf] span[ptile=1]}" "bash ~/shared/caffe_multi_node.sh"
