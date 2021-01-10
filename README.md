# spring-kafka-bug

A "hello world" demo of Spring for Apache Kafka that illustrates an issue (which I don't understand yet) due to Java 15 (classloading?).

## Bug

Look at the [results of the GitHub Actions CI](https://github.com/dgroomes/spring-kafka-java-15-bug/actions) to see how 
building and running the app using Java 15 results in a `java.lang.ClassNotFoundException: com.fasterxml.jackson.databind.JsonNode`
but the Java 11 execution starts up fine (although errors because I didn't set up Kafka in the CI environment but that's
beyond the scope of reproducing the defect.)

## Instructions

Follow these instructions to build and run locally:
* Use Java 11
* Start Zookeeper and Kafka in Docker containers:
  `docker-compose up -dV` 
* Start the app:
  `./gradlew bootRun`
* Produce a message:
  `./produce-message.sh`
* From the app logs you should see that the message was received:
  ```
  1-01-10 15:04:33.073  INFO 95960 --- [ntainer#0-0-C-1] dgroomes.springkafkabug.Listener         : Received message: hello world
  ```
* Stop the containers:
  `docker-compose down`

Alternatively follow these instructions to re-produce the Java 15-related bug:

* Use Java **15**
* Start Zookeeper and Kafka in Docker containers:
  `docker-compose up -dV`
* Start the app:
  `./gradlew bootRun`
* The application will fail at runtime with this log statement:
  ```
  java.lang.NoClassDefFoundError: com/fasterxml/jackson/databind/JsonNode
          at org.apache.kafka.clients.consumer.internals.AbstractCoordinator.sendFindCoordinatorRequest(AbstractCoordinator.java:787) ~[kafka-clients-2.6.0.jar:na]
          at org.apache.kafka.clients.consumer.internals.AbstractCoordinator.lookupCoordinator(AbstractCoordinator.java:269) ~[kafka-clients-2.6.0.jar:na]
          at org.apache.kafka.clients.consumer.internals.AbstractCoordinator.ensureCoordinatorReady(AbstractCoordinator.java:236) ~[kafka-clients-2.6.0.jar:na]
          at org.apache.kafka.clients.consumer.internals.ConsumerCoordinator.poll(ConsumerCoordinator.java:485) ~[kafka-clients-2.6.0.jar:na]
          at org.apache.kafka.clients.consumer.KafkaConsumer.updateAssignmentMetadataIfNeeded(KafkaConsumer.java:1268) ~[kafka-clients-2.6.0.jar:na]
          at org.apache.kafka.clients.consumer.KafkaConsumer.poll(KafkaConsumer.java:1230) ~[kafka-clients-2.6.0.jar:na]
          at org.apache.kafka.clients.consumer.KafkaConsumer.poll(KafkaConsumer.java:1210) ~[kafka-clients-2.6.0.jar:na]
          at org.springframework.kafka.listener.KafkaMessageListenerContainer$ListenerConsumer.doPoll(KafkaMessageListenerContainer.java:1269) ~[spring-kafka-2.6.4.jar:2.6.4]
          at org.springframework.kafka.listener.KafkaMessageListenerContainer$ListenerConsumer.pollAndInvoke(KafkaMessageListenerContainer.java:1160) ~[spring-kafka-2.6.4.jar:2.6.4]
          at org.springframework.kafka.listener.KafkaMessageListenerContainer$ListenerConsumer.run(KafkaMessageListenerContainer.java:1073) ~[spring-kafka-2.6.4.jar:2.6.4]
          at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:515) ~[na:na]
          at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264) ~[na:na]
          at java.base/java.lang.Thread.run(Thread.java:832) ~[na:na]
  Caused by: java.lang.ClassNotFoundException: com.fasterxml.jackson.databind.JsonNode
          at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:606) ~[na:na]
          at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:168) ~[na:na]
          at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:522) ~[na:na]
          ... 13 common frames omitted
  ```
