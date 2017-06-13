topo=$1
for node in 2 4 8 16 32 
#64 128
do
    ./submit_job.sh $node knl $topo
done
