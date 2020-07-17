#!/bin/bash

if [ "$1" == "scale" -a "$#" -ne 3 ]
then
    echo "$0 {[start|stop]] profile} | {scale profile nodes}"
    exit 1
elif [ "$1" != "scale" -a "$#" -ne 2 ]
then
    echo "$0 {[start|stop]] profile} | {scale profile nodes}"
    exit 1
fi

MODE=$1
PROFILE=$2
NODES=$3

export PROFILE

case "$MODE" in
   "start")
      docker-compose -f docker-compose-$PROFILE.yml -p $PROFILE up
      ;;
   "stop")
      docker-compose -f docker-compose-$PROFILE.yml -p $PROFILE down
      ;;
   "scale")
      docker-compose -f docker-compose-$PROFILE.yml -p $PROFILE scale kafka=$NODES
      ;;
   *)
     echo "Invalid mode $MODE"
     exit 1
     ;;
esac