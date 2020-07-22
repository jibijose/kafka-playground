#!/bin/bash

./scripts/java_cleanup_all.sh
./scripts/docker_cleanup_all.sh
echo "Cleaned java and docker"
echo "******************************************************************"

./kafka_start_stop_scale.sh start sdc
echo "Started kafka and zookeeper in sdc"
./kafka_start_stop_scale.sh start wdc
echo "Started kafka and zookeeper in wdc"
echo "******************************************************************"

./kafka_start_stop_scale.sh scale sdc 3
echo "Scaled kafka in sdc"
./kafka_start_stop_scale.sh scale wdc 3
echo "Scaled kafka in wdc"
echo "******************************************************************"

./scripts/createTopic.sh 192.168.1.8 sdc sdc.topic 2 6
echo "Created topic sdc.topic in sdc"
./scripts/createTopic.sh 192.168.1.8 sdc wdc.topic 2 6
echo "Created topic wdc.topic in sdc"
./scripts/createTopic.sh 192.168.1.8 wdc wdc.topic 2 6
echo "Created topic wdc.topic in wdc"
./scripts/createTopic.sh 192.168.1.8 wdc sdc.topic 2 6
echo "Created topic sdc.topic in wdc"
echo "******************************************************************"

rm -rf *_mm2.log
nohup  ./startMirrorMaker2.sh 192.168.1.8  sdc wdc.topic > sdc_mm2.log 2>&1 &
echo "Started mirror maker 2.x in sdc"
nohup  ./startMirrorMaker2.sh 192.168.1.8  wdc sdc.topic > sdc_mm2.log 2>&1 &
echo "Started mirror maker 2.x in wdc"
echo "******************************************************************"

echo "All started successfully"