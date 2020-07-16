#!/bin/bash

HOST_IP=192.168.1.8
PROFILE=sdc

function check_zookeeper_status_ok() {
    ZOOKEEPER_INDEX=$1
    ZOOKEEPER_PORT=$(docker inspect "$PROFILE"_zookeeper_"$ZOOKEEPER_INDEX" | jq -r '.[].NetworkSettings.Ports."2181/tcp"[0].HostPort')
    STATUS=$(echo ruok | nc $HOST_IP $ZOOKEEPER_PORT)
    echo "Zookeeper[$ZOOKEEPER_INDEX] $HOST_IP:$ZOOKEEPER_PORT status is $STATUS"
}

num_of_zks=$(docker ps -a | grep "_zookeeper_" | wc -l)

for ((i=1;i<=$num_of_zks;i++)); 
do 
    check_zookeeper_status_ok $i
done
