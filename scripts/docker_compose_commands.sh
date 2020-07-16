#!/bin/bash

docker-compose -p sdc scale zookeeper=1
docker-compose -p sdc scale kafka=3

HOST_IP=192.168.1.8
TOPIC_NAME=testtopic
ZOOKEEPER_PORT="$(docker-compose -p sdc port zookeeper 2181 | cut -d':' -f2)"
KAFKA_PORT="$(docker-compose -p sdc port kafka 9092 | cut -d':' -f2)"
#$KAFKA_HOME/bin/kafka-topics --delete --topic $TOPIC_NAME --bootstrap-server $HOST_IP:$KAFKA_PORT


$KAFKA_HOME/bin/kafka-run-class kafka.tools.GetOffsetShell --broker-list $HOST_IP:$KAFKA_PORT --topic $TOPIC_NAME --time -1
$KAFKA_HOME/bin/kafka-consumer-groups --bootstrap-server $HOST_IP:$KAFKA_PORT  --describe --all-groups


$KAFKA_HOME/bin/kafka-topics --alter --bootstrap-server $HOST_IP:$KAFKA_PORT --topic $TOPIC_NAME --partitions 5
$KAFKA_HOME/bin/kafka-topics --alter --bootstrap-server $HOST_IP:$KAFKA_PORT --topic $TOPIC_NAME --partitions 5  --replication-factor 1
$KAFKA_HOME/bin/kafka-topics --alter --bootstrap-server $HOST_IP:$KAFKA_PORT --topic $TOPIC_NAME --partitions 5

#https://cwiki.apache.org/confluence/display/KAFKA/Replication+tools
#https://medium.com/@marcelo.hossomi/running-kafka-in-docker-machine-64d1501d6f0b

