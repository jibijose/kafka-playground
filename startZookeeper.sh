#!/bin/bash

docker-compose -f docker-compose-zookeeper.yml -p zookeeper down
echo "******************************************************************************************"
docker-compose -f docker-compose-zookeeper.yml -p zookeeper up
