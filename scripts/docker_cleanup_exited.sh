#!/bin/bash

docker stop $(docker ps -aq -f status=exited)
docker rm $(docker ps -aq -f status=exited)

echo "docker stopped and removed exited containers."