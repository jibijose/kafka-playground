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

function check_kafka_status_ok() {
    KAFKA_INDEX=$1
    KAFKA_PORT=$(docker inspect "$PROFILE"_kafka_"$KAFKA_INDEX" | jq -r '.[].NetworkSettings.Ports."9092/tcp"[0].HostPort')
    STATUS=$(echo ruok | nc $HOST_IP $ZOOKEEPER_PORT)
    echo "Kafka[$KAFKA_INDEX] $HOST_IP:$KAFKA_PORT status is $STATUS"
}

num_of_kafkas=$(docker ps -a | grep "$PROFILE"_kafka_[0-9] | wc -l)
zk_listed_kafkas=$($KAFKA_HOME/bin/zookeeper-shell $ZK_LIST ls /brokers/ids | grep "\[*\]")

echo "Number of kafka docker instances $num_of_kafkas"
echo "Kafka brokers listed in zookeeper $zk_listed_kafkas"
echo

echo  "All topics list"
$KAFKA_HOME/bin/kafka-topics --list --bootstrap-server $BROKERS_LIST
echo
echo  "All brokers list"
$KAFKA_HOME/bin/kafka-topics --describe --topic $TOPIC_NAME --bootstrap-server $BROKERS_LIST
echo

echo  "Brokers list with unavailable partitions"
$KAFKA_HOME/bin/kafka-topics --describe --topic $TOPIC_NAME --bootstrap-server $BROKERS_LIST --unavailable-partitions
echo

echo  "Brokers list with under replicated partitions"
$KAFKA_HOME/bin/kafka-topics --describe --topic $TOPIC_NAME --bootstrap-server $BROKERS_LIST --under-replicated-partitions
echo
