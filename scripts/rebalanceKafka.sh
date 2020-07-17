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

CONTAINERS=$(docker ps | grep $PROFILE | grep 2181 | awk '{print $1}')
ZK_LIST=$(for CONTAINER in ${CONTAINERS}; do docker port "$CONTAINER" 2181 | sed -e "s/0.0.0.0:/$HOST_IP:/g"; done)
ZK_LIST=$(echo $ZK_LIST | sed 's/ /,/g')
echo "ZK_LIST = $ZK_LIST"

BROKER_ID_LIST=$($KAFKA_HOME/bin/zookeeper-shell $ZK_LIST ls /brokers/ids | grep "\[*\]"  | sed 's/\[//g' | sed 's/\]//g' | sed 's/ //g')
echo "Broker ID list $BROKER_ID_LIST"

rm -rf rjf.json t2m-$TOPIC_NAME.json
cat t2m.json | sed "s/TOPIC_NAME/${TOPIC_NAME}/g" > t2m-$TOPIC_NAME.json
$KAFKA_HOME/bin/kafka-reassign-partitions --bootstrap-server $BROKERS_LIST --generate --zookeeper $ZK_LIST --topics-to-move-json-file t2m-$TOPIC_NAME.json --broker-list $BROKER_ID_LIST | tail -1 > rjf.json
$KAFKA_HOME/bin/kafka-reassign-partitions --bootstrap-server $BROKERS_LIST --execute --zookeeper $ZK_LIST --reassignment-json-file rjf.json

$KAFKA_HOME/bin/kafka-leader-election --bootstrap-server $BROKERS_LIST --election-type preferred --all-topic-partitions
echo "******************************************************************"
./scripts/kafka_status.sh $HOST_IP $PROFILE $TOPIC_NAME