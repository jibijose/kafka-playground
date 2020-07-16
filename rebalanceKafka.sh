#!/bin/bash

HOST_IP=192.168.1.8
PROFILE=sdc
ZOOKEEPER_PORT="$(docker-compose -p sdc port zookeeper 2181 | cut -d':' -f2)"
KAFKA_PORT="$(docker-compose -p sdc port kafka 9092 | cut -d':' -f2)"
TOPIC_NAME=testtopic

./scripts/kafka_status.sh 
echo "******************************************************************"
docker-compose -p sdc scale kafka=1
echo "Kafka scaled to 1 node"
./scripts/kafka_status.sh 
echo "******************************************************************"
docker-compose -p sdc scale kafka=3
echo "Kafka scaled to 3 nodes"
./scripts/kafka_status.sh 
echo "******************************************************************"

BROKER_LIST=$($KAFKA_HOME/bin/zookeeper-shell $HOST_IP:$ZOOKEEPER_PORT ls /brokers/ids | grep "\[*\]"  | sed 's/\[//g' | sed 's/\]//g' | sed 's/ //g')
echo "Brokers list $BROKER_LIST"

rm -rf rjf.json
$KAFKA_HOME/bin/kafka-reassign-partitions --bootstrap-server $HOST_IP:$KAFKA_PORT --generate --zookeeper $HOST_IP:$ZOOKEEPER_PORT --topics-to-move-json-file t2m.json --broker-list $BROKER_LIST | tail -1 > rjf.json
$KAFKA_HOME/bin/kafka-reassign-partitions --bootstrap-server $HOST_IP:$KAFKA_PORT --execute --zookeeper $HOST_IP:$ZOOKEEPER_PORT --reassignment-json-file rjf.json
./scripts/kafka_status.sh 
echo "******************************************************************"

$KAFKA_HOME/bin/kafka-leader-election --bootstrap-server $HOST_IP:$KAFKA_PORT --election-type preferred --all-topic-partitions
./scripts/kafka_status.sh 