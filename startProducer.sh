#!/bin/bash

if [ "$#" -ne 3 ]
then
    echo "$0 host_ip profile topic_name"
    exit 1
fi

HOST_IP=$1
PROFILE=$2
TOPIC_NAME=$3

CONTAINERS=$(docker ps | grep $PROFILE | grep 9092 | awk '{print $1}')
BROKERS_LIST=$(for CONTAINER in ${CONTAINERS}; do docker port "$CONTAINER" 9092 | sed -e "s/0.0.0.0:/$HOST_IP:/g"; done)
BROKERS_LIST=$(echo $BROKERS_LIST | sed 's/ /,/g')
echo "BROKERS_LIST = $BROKERS_LIST"

$KAFKA_HOME/bin/kafka-console-producer --topic $TOPIC_NAME --bootstrap-server $BROKERS_LIST
echo "******************************************************************************************"
