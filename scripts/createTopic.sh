#!/bin/bash

if [ "$#" -ne 5 ]
then
    echo "$0 host_ip profile topic_name replication_factor partitions"
    exit 1
fi

HOST_IP=$1
PROFILE=$2
TOPIC_NAME=$3
REPLICATION_FACTOR=$4
PARTITIONS=$5

CONTAINERS=$(docker ps | grep $PROFILE | grep 9092 | awk '{print $1}')
BROKERS_LIST=$(for CONTAINER in ${CONTAINERS}; do docker port "$CONTAINER" 9092 | sed -e "s/0.0.0.0:/$HOST_IP:/g"; done)
BROKERS_LIST=$(echo $BROKERS_LIST | sed 's/ /,/g')
echo "BROKERS_LIST = $BROKERS_LIST"

$KAFKA_HOME/bin/kafka-topics --create --bootstrap-server $BROKERS_LIST --replication-factor $REPLICATION_FACTOR --partitions $PARTITIONS --topic $TOPIC_NAME
echo "******************************************************************************************"
