#!/bin/bash

# write config for later runs.
echo  "${NETSERVER_ADDRESSES}" > /netserver_addresses
echo  "${NETSERVER_ZONES}" > /netserver_zones

cat << 'HEREDOC' > /root/benchmark.bash4
#!/bin/bash
# run benchmark
readarray -t ZONES < /netserver_zones
readarray -t ADDRESSES < /netserver_addresses
ZONES_COUNT=$${#ZONES[@]}

for (( i=0; i<$${ZONES_COUNT}; i++ )); do
    ZONE=$${ZONES[$i]}
    ADDRESS=$${ADDRESSES[$i]}
    NAME=$${HOSTNAME}-to-$${ZONE}
    STAMP=`date +%Y-%m-%dT%H%M%S.%6N`
    flent rrul -p all_scaled -l 60 -H $${ADDRESS} -t $${NAME} -o /root/$${NAME}.rrul-$${STAMP}.png
done;

# rename output so alpha sort groups by  flent location.
for x in `ls -1 /root/ | grep -e ^rrul-.*.gz`; do
  DST=`echo $x | awk -F '.' '{print $3"."$1"."$2".gz"; }'`;
  mv /root/$x /root/$DST ;
done;
HEREDOC

# make benchmark executable
chmod +x /root/benchmark.bash4
# run benchmarks
/root/benchmark.bash4

# change perms so benchmark results can easily be scp'd off the server.
chmod +xr /root
chmod +r /root/*

# TODO: copy the benchmark results to someplace more useful, like elasticsearch or mongo where they can be processed in more detail.
