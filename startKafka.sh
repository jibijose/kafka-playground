#!/bin/bash

docker-compose -p sdc down
echo "******************************************************************************************"
./scripts/docker_cleanup_all.sh
echo "******************************************************************************************"
docker-compose -p sdc up
#docker-compose -p sdc up -d --scale zookeeper=3 zookeeper
#docker-compose -p sdc up -d --scale kafka=3 kafka
