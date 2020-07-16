#!/bin/bash

docker-compose -f docker-compose-wdc.yml -p wdc down
echo "******************************************************************************************"
docker-compose -f docker-compose-wdc.yml -p wdc up
