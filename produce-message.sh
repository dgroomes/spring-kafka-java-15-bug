#!/usr/bin/env bash
# Produce a message to the Kafka topic.
#
# This command executes a command from inside the Kafka Docker container. Alternatively, if you have the Kafka commandline
# tools installed locally then you can execute the command from your host instead of from inside the container.

echo "hello world" |\
  docker exec -i spring-kafka-java-15-bug_kafka_1 \
  kafka-console-producer --broker-list kafka:9092 --topic my-messages
