#!/bin/bash

HOST_IP=192.168.1.8
PROFILE=sdc
ZOOKEEPER_PORT="$(docker-compose -f docker-compose-zookeeper.yml -p zookeeper port zookeeper 2181 | cut -d':' -f2)"
KAFKA_PORT_SDC="$(docker-compose -f docker-compose-sdc.yml -p sdc port kafka 9092 | cut -d':' -f2)"
KAFKA_PORT_WDC="$(docker-compose -f docker-compose-wdc.yml -p wdc port kafka 9092 | cut -d':' -f2)"
TOPIC_NAME=testtopic

function check_kafka_status_ok() {
    KAFKA_INDEX=$1
    KAFKA_PORT=$(docker inspect "$PROFILE"_kafka_"$KAFKA_INDEX" | jq -r '.[].NetworkSettings.Ports."9092/tcp"[0].HostPort')
    STATUS=$(echo ruok | nc $HOST_IP $ZOOKEEPER_PORT)
    echo "Kafka[$KAFKA_INDEX] $HOST_IP:$KAFKA_PORT status is $STATUS"
}

num_of_kafkas=$(docker ps -a | grep "_kafka_" | wc -l)
zk_listed_kafkas=$($KAFKA_HOME/bin/zookeeper-shell $HOST_IP:$ZOOKEEPER_PORT ls /brokers/ids | grep "\[*\]")

echo "Number of kafka docker instances $num_of_kafkas"
echo "Kafka brokers listed in zookeeper $zk_listed_kafkas"
echo

echo  "All topics list"
$KAFKA_HOME/bin/kafka-topics --list --bootstrap-server $HOST_IP:$KAFKA_PORT_SDC,$HOST_IP:$KAFKA_PORT_WDC
echo
echo  "All brokers list"
$KAFKA_HOME/bin/kafka-topics --describe --topic $TOPIC_NAME --bootstrap-server $HOST_IP:$KAFKA_PORT_SDC,$HOST_IP:$KAFKA_PORT_WDC
echo

echo  "Brokers list with unavailable partitions"
$KAFKA_HOME/bin/kafka-topics --describe --topic $TOPIC_NAME --bootstrap-server $HOST_IP:$KAFKA_PORT_SDC,$HOST_IP:$KAFKA_PORT_WDC --unavailable-partitions
echo

echo  "Brokers list with under replicated partitions"
$KAFKA_HOME/bin/kafka-topics --describe --topic $TOPIC_NAME --bootstrap-server $HOST_IP:$KAFKA_PORT_SDC,$HOST_IP:$KAFKA_PORT_WDC --under-replicated-partitions
echo
