#!/bin/bash

if [ "$#" -ne 3 ]
then
    echo "$0 host_ip profile topic_name"
    exit 1
fi

HOST_IP=$1
PROFILE=$2
TOPIC_NAME=$3

PROFILEVAR=sdc
CONTAINERS=$(docker ps | grep $PROFILEVAR | grep 9092 | awk '{print $1}')
SDC_BROKERS_LIST=$(for CONTAINER in ${CONTAINERS}; do docker port "$CONTAINER" 9092 | sed -e "s/0.0.0.0:/$HOST_IP:/g"; done)
SDC_BROKERS_LIST=$(echo $SDC_BROKERS_LIST | sed 's/ /,/g')
echo "SDC BROKERS_LIST = $SDC_BROKERS_LIST"

PROFILEVAR=wdc
CONTAINERS=$(docker ps | grep $PROFILEVAR | grep 9092 | awk '{print $1}')
WDC_BROKERS_LIST=$(for CONTAINER in ${CONTAINERS}; do docker port "$CONTAINER" 9092 | sed -e "s/0.0.0.0:/$HOST_IP:/g"; done)
WDC_BROKERS_LIST=$(echo $WDC_BROKERS_LIST | sed 's/ /,/g')
echo "WDC BROKERS_LIST = $WDC_BROKERS_LIST"

if [ "$PROFILE" == "wdc" ]
then
    rm -rf wdc_*_consumer.properties
    cat ./templates/consumer.properties | sed "s/CONSUMER_BROKER_LIST/$SDC_BROKERS_LIST/g" >> wdc_mm2_consumer.properties
    cat ./templates/producer.properties | sed "s/PRODUCER_BROKER_LIST/$WDC_BROKERS_LIST/g" >> wdc_mm2_producer.properties
    $KAFKA_HOME/bin/kafka-mirror-maker --producer.config wdc_mm2_producer.properties --consumer.config wdc_mm2_consumer.properties --whitelist $TOPIC_NAME
elif [ "$PROFILE" == "sdc" ]
then
    rm -rf sdc_*_consumer.properties
    cat ./templates/consumer.properties | sed "s/CONSUMER_BROKER_LIST/$WDC_BROKERS_LIST/g" >> sdc_mm2_consumer.properties
    cat ./templates/producer.properties | sed "s/PRODUCER_BROKER_LIST/$SDC_BROKERS_LIST/g" >> sdc_mm2_producer.properties
    $KAFKA_HOME/bin/kafka-mirror-maker --producer.config sdc_mm2_producer.properties --consumer.config sdc_mm2_consumer.properties --whitelist $TOPIC_NAME
fi


