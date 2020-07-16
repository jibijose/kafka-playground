#!/bin/bash

docker-compose -f docker-compose-sdc.yml -p sdc down
echo "******************************************************************************************"
docker-compose -f docker-compose-sdc.yml -p sdc up
