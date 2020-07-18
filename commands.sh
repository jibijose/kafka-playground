#!/bin/bash
exit
echo "******************************************************************************"

./scripts/docker_cleanup_all.sh

./kafka_start_stop_scale.sh start sdc
./kafka_start_stop_scale.sh start wdc


./kafka_start_stop_scale.sh scale sdc 3
./kafka_start_stop_scale.sh scale wdc 3
./scripts/createTopic.sh 192.168.1.8 sdc sdc.topic 2 6
./scripts/createTopic.sh 192.168.1.8 sdc wdc.topic 2 6
./scripts/createTopic.sh 192.168.1.8 wdc wdc.topic 2 6
./scripts/createTopic.sh 192.168.1.8 wdc sdc.topic 2 6



./startMirrorMaker2.sh 192.168.1.8  sdc wdc.topic 

./scripts/kafka_status.sh 192.168.1.8 sdc sdc.topic
./scripts/kafka_status.sh 192.168.1.8 wdc wdc.topic
./scripts/rebalanceKafka.sh 192.168.1.8  sdc sdc.topic




echo "******************************************************************************"
docker run -it wurstmeister/kafka /bin/bash
docker exec -it CONTAINERID /bin/bash
echo "******************************************************************************"

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

#https://github.com/docker-solr/docker-solr/issues/52

#https://www.altoros.com/blog/multi-cluster-deployment-options-for-apache-kafka-pros-and-cons/
#https://gist.github.com/dongjinleekr/d24e3d0c7f92ac0f80c87218f1f5a02b
https://github.com/tmcgrath/kafka-streams-java


https://blog.cloudera.com/a-look-inside-kafka-mirrormaker-2/
https://dzone.com/articles/mirror-maker-v20
https://medium.com/@amalaruja/running-apache-kafka-mirror-maker-on-kubernetes-229bc2ae7084
https://www.instaclustr.com/support/documentation/kafka/kafka-cluster-operations/setting-up-mirror-maker/
echo "******************************************************************************"


 