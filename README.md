# Exercise on mqtt cluster

## Files

The project is composed of :

- README.md
- create_iot_mqtt_docker_image.sh
- delete_iot_mqtt_docker_image.sh
- run_emqtt_container_node_1.sh
- run_emqtt_container_node_1.sh
- run_publisher_container.sh
- run_subscriber_container.sh
- docker-files
  - Dockerfile
  - modify_emq_conf_file.sh
  - publisher.sh
  - subscriber.sh
  - persisters_configuration_file.json
  - jars
    - iot-mqtt-1.0-SNAPSHOT-jar-with-dependencies.jar

## Context

This project enables to run 4 docker containers.

On two of these containers (named `s1-emqtt-io` and `s2-emqtt-io`) we will setup a mqtt cluster. We will also run a tcpdump capture in order to visualize the packets exchanged with clients.

On one of the two other containers (named `publisher`), we will run a publisher to send messages to the mqtt cluster. On the other containers (named `subsciber`) we will run a subscriber with the possibility to persist messages on console or on elasticsearch. With Kibana we will be able to visualize those messages. 

## Build the docker image

Execute the script `create_iot_mqtt_docker_image.sh` to create the image `iot-mqtt-docker-image:0.0.1`.

If you want to delete this image, you can run the script `delete_iot_mqtt_docker_image.sh`.

## Setup the EMQTT cluster

To setup a mqtt cluster we decide to use the feature `EMQTT` because it is open-source and has more functionnalities than others (see https://github.com/mqtt/mqtt.github.io/wiki/server-support)

On two terminals run the scripts `run_emqtt_container_node_1.sh` and `run_emqtt_container_node_2.sh`. Two containers should be named `s1-emqtt-io` and `s2-emqtt-io`.

Then on each container

	cd /home
	sh modify_emq_conf_file.sh

Check that the file `/etc/emqttd/emq.conf` has been changed at the end.

	emqttd start
	emqttd_ctl cluster status

## Test the EMQTT cluster with Mosquitto

Mosquitto is an open-source project that enables to publish and subscriber to any mqtt cluster.

on s1-emqtt-io

	mosquitto_sub -h s2-emqtt-io -t iot_data

on s2-emqtt-io
	
	mosquitto_pub -h s1-emqtt-io -t iot_data -m "Hello IoT"

You should see the message "Hello IoT" display on `s1-emqtt-io`

## Elasticsearch

On subscriber 

	su - elasticuser
	export JAVA_HOME=/usr/bin/java/jdk1.8.0_161
	./elasticsearch/bin/elasticsearch > /dev/null 2>&1 &
	exit
	curl -XPUT 'http://localhost:9200/index_test/messages/first' -H "Content-Type: application/json" -d '{"name" : "xebia & iot-ee"}'

## Kibana

on subscriber

	/usr/share/kibana/bin/kibana > /dev/null 2>&1 &
	
On your local desktop, open a browser and go to 

	localhost:5601

Verify index "index_test" was created

## Setup publisher and subscriber

On two terminals, execute run_publisher_container.sh and run_subscriber_container.sh. Two containers should be named `publisher` and `subscriber`.

On publisher

	cd /home
	sh publisher.sh tcp://s2-emqtt-io:1883 iot_data_test

On subscriber

	cd /home
	sh subscriber.sh tcp://s1-emqtt-io:1883 iot_data_test persisters_configuration_file.json

## HTTP Publisher 

PS: Link followed `https://github.com/emqtt/emqttd/issues/1274`

	curl -v --basic -u admin:public -H "Content-Type: application/json" -d '{"topic": "test","payload": "hello","qos": 1,"retain": false,"client_id": "C_1492145414740"}' -k http://localhost:8080/api/v2/mqtt/publish

## Analysis of network exchange

Let's analyze the packets exchanged between clients and the MQTT cluster. You can execute on `s1-emqtt-io`, the following command:

	tcpdump -w capture_network_exchange.pcap


With all methods we have seen, publish and subscribe messages from `s1-emqtt-io`, then retrieve the file `capture_network_exchange.pcap` on your local desktop by executing the command below on a new terminal:

	docker cp <CONTAINER_ID_of_s1-emqtt-io>:/capture_network_exchange.pcap .

The file format `pcap` is readable with wireshark, thus download `wireshark` and open it. Finally, analyse the packet exchanged.


