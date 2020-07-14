

docker-compose up zookeeper
docker-compose up kafka
docker-compose up

docker-compose scale zookeeper=3
docker-compose scale kafka=3

docker ps -a
docker inspect kafka-playground_kafka_1
docker inspect --format '{{ .NetworkSettings.IPAddress }}' kafka-playground_kafka_1


./kafka-console-producer.sh --topic test-topic-1 --bootstrap-server 192.168.1.8:9092
./kafka-console-consumer.sh --topic test-topic-1 --bootstrap-server 192.168.1.8:9092


./kafka-console-producer.sh --topic test-topic-1 --bootstrap-server 172.23.0.1:32771
./kafka-console-consumer.sh --topic test-topic-1 --bootstrap-server 172.23.0.1:32771