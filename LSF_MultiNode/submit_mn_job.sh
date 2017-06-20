#!/bin/bash

N=4
JOBID=1
#bsub -W 2:00 -n $N -J skl$N-$JOBID -q inteldevq -o skl_$N-$JOBID.out -e skl_$N-$JOBID.err -R "{select[epb] span[ptile=1]}" "sh run_endv.script $N /panfs/users/wangwei3/intelcaffe knl googlenet $JOBID"
#bsub -W 2:00 -n $N -J skl$N-$JOBID -q inteldevq -o skl_$N-$JOBID.out -e skl_$N-$JOBID.err -R "{select[epb] span[ptile=1]}" "bash simple.script"
bsub -W 0:20 -n $N -J knl$N-$JOBID -q inteldevq -o knl_$N-$JOBID.out -e knl_$N-$JOBID.err -R "4*{select[ekf] span[ptile=1]}" "bash ~/shared/caffe_multi_node.sh"
