#!/bin/bash

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

echo "docker stopped and removed all containers."


#docker network prune -f