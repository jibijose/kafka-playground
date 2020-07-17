#!/bin/bash

if [ "$#" -ne 2 ]
then
    echo "$0 host_ip profile"
    exit 1
fi

HOST_IP=$1
PROFILE=$2

function check_zookeeper_status_ok() {
    ZOOKEEPER_INDEX=$1
    ZOOKEEPER_PORT=$(docker inspect "$PROFILE"_zookeeper"$ZOOKEEPER_INDEX"_1 | jq -r '.[].NetworkSettings.Ports."2181/tcp"[0].HostPort')
    STATUS=$(echo ruok | nc $HOST_IP $ZOOKEEPER_PORT)
    echo "Zookeeper[$ZOOKEEPER_INDEX] $HOST_IP:$ZOOKEEPER_PORT status is $STATUS"
}

num_of_zks=$(docker ps -a | grep "$PROFILE"_zookeeper[0-9]_[0-9] | wc -l)

for ((i=1;i<=$num_of_zks;i++)); 
do 
    check_zookeeper_status_ok $i
done
