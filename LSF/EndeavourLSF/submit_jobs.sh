#!/bin/bash
set -x

parent_path="."
branch="intelcaffe"
timeout=1
topo=googlenet
cpu=knl
node_num=2
mode=time
queue=""
arch=""
iteration=1000
run_times=3
# 0 means global batch size is 1024. local batch size = global batch size / node number.
batch_size=0 

function usage
{
  echo "Usage:"
  echo "    $0 ini_file"
}

if [ $# -lt 1 ]; then
  usage
  exit 1
fi

ini_file=$1
if [ ! -f $ini_file ]; then
  echo "Error: $ini_file doesn't exist."
  exit 1
fi

while read line
do
  if [[ $line = \#* ]]; then
    echo "comments: $line"
    continue
  fi

  if [[ $line != *=* ]]; then
    continue
  fi

  var=`echo $line | awk -F '=' '{print $1}'`
  value=`echo $line | awk -F '=' '{print $2}'`
  sub_value=`echo $line | awk -F '=' '{print $3}'`

  case $var in
    caffe_parent_path)
      parent_path=$value
      ;;
    branch)
      branch=$value
      ;;
    topo)
      topo=$value
      ;;
    mode)
      mode=$value
      ;;
    timeout)
      timeout=$value
      ;;
    node_num)
      node_num=$value
      ;;
    cpu)
      cpu=$value
      ;;
    iteration)
      iteration=$value
      ;;
    run_times)
      run_times=$value
      ;;
    batch_size)
      batch_size=$value
      ;;
    *)
      echo "Invalid parameter: " $line
      exit 1
      ;;
  esac
done < $ini_file

if [ "$cpu" == "bdw" ];
then
    queue=workq
    arch=bdwx
elif [ "$cpu" == "knl" ];
then
    queue=inteldevq
    arch=ekf
elif [ "$cpu" == "skl" ]; then
    queue=inteldevq
    arch=epb
else
    echo "Invalid cpu: $cpu"
    exit 1
fi

topo_short="$(echo $topo | head -c 1)"

max_node_num=0
node_num_list=($(echo $node_num | sed "s/,/ /g"))
for nn in ${node_num_list[@]}
do
  if [ $nn -gt $max_node_num ];
  then
    let max_node_num=nn
  fi
done

job_name="$topo_short""$cpu""$max_node_num"
out_file="$job_name".out
err_file="$job_name".err
res_req="{select[$arch] span[ptile=1]}"
if [ "$parent_path" == "" ]; then
  parent_path=$PWD
elif [[ "$parent_path" != /* ]]; then
  parent_path=$(cd $parent_path; pwd)
#  temp_path=$PWD/$parent_path
#  parent_path=$temp_path
fi
job_command="sh run_endv.script $node_num $parent_path $cpu $topo $branch $run_times $iteration $batch_size $mode"

echo "**********************************************"
echo "Parameters"
echo "    Parent path: $parent_path"
echo "    Source directory: $branch"
echo "    Topology: $topo"
echo "    Mode: $mode"
echo "    Number of run: $run_times"
echo "    Iteration: $iteration"
echo "    Batch size: $batch_size"
echo "    Node number: $node_num"
echo "    CPU: $cpu"
echo "    Timeout: $timeout"
echo "    Command: $job_command"
echo "    Job name: $job_name"
echo "**********************************************"

bsub -W $timeout -n $max_node_num -J $job_name -q $queue -o $out_file -e $err_file -R "$res_req" "$job_command" -l HFI1_num_user_contexts=16 -l HFI1_max_mtu=10240 -l HFI1_cache_size=4096
