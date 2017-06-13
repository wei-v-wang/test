

for node_num in 2 4 8
do
 for ((i=0; i<3; i++))
 do
  echo $node_num
  head -$node_num mpd.hosts.8nodes >mpd.hosts
  ./train.sh
  python extract_time.py out.log > time.log
  node_dir="$node_num"nodes"_$i"
  mkdir $node_dir
  mv out.log time.log $node_dir
  mv mpd.hosts $node_dir
 done
d
