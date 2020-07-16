#!/bin/bash

HOST_IP=192.168.1.8
TOPIC_NAME=testtopic
REPLICATION_FACTOR=3
PARTITIONS=5

KAFKA_PORT="$(docker-compose -p sdc port kafka 9092 | cut -d':' -f2)"
echo "Kafka broker is $HOST_IP:$KAFKA_PORT"
$KAFKA_HOME/bin/kafka-topics --create --bootstrap-server $HOST_IP:$KAFKA_PORT --replication-factor $REPLICATION_FACTOR --partitions $PARTITIONS --topic $TOPIC_NAME
echo "******************************************************************************************"
