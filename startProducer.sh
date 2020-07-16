#!/bin/bash

HOST_IP=192.168.1.8
TOPIC_NAME=testtopic
REPLICATION_FACTOR=1
PARTITIONS=1

KAFKA_PORT="$(docker-compose -p sdc port kafka 9092 | cut -d':' -f2)"
echo "Kafka broker is $HOST_IP:$KAFKA_PORT"
$KAFKA_HOME/bin/kafka-console-producer --topic $TOPIC_NAME --bootstrap-server $HOST_IP:$KAFKA_PORT
echo "******************************************************************************************"
