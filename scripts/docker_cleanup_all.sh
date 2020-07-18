#!/bin/bash

pkill -f "java"

numofps=`docker ps -aq | wc  -l`
if [ $numofps -ne 0 ]
then
    docker stop $(docker ps -aq)
fi
echo "docker stopped all containers."

numofps=`docker ps -aq | wc  -l`
if [ $numofps -ne 0 ]
then
    docker rm $(docker ps -aq)
fi
echo "docker removed all containers."

numofps=`docker volume ls -q | wc  -l`
if [ $numofps -ne 0 ]
then
    docker volume rm $(docker volume ls -q)
fi
echo "docker removed all volumes."

docker network prune -f
echo "docker pruned all networks."