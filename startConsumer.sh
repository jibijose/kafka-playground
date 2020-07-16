#!/bin/bash

HOST_IP=192.168.1.8
TOPIC_NAME=testtopic
CONSUMER_GROUP=mygroup

KAFKA_PORT="$(docker-compose -p sdc port kafka 9092 | cut -d':' -f2)"
echo "Kafka broker is $HOST_IP:$KAFKA_PORT"
$KAFKA_HOME/bin/kafka-console-consumer --topic $TOPIC_NAME --bootstrap-server $HOST_IP:$KAFKA_PORT --group $CONSUMER_GROUP
echo "******************************************************************************************"
