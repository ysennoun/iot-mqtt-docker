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
  - jars
    - iot-mqtt-1.0-SNAPSHOT-jar-with-dependencies.jar

## Context

This project enables to run 4 docker containers.

On two of these containers (named s1-emqtt-io and s2-emqtt-io) we will setup a mqtt cluster. We will also run a wireshark in order to visualize the packets exchanged with clients.

On one of the two others containers (named publisher), we will run a publisher to send messages to the mqtt cluster. On the other containers (named subsciber) we will run a subscriber with the possibility to persist messages on console or on elasticsearch. With Kibana we will be able to visualize those messages. 

## Build the docker image

Execute the script create_iot_mqtt_docker_image.sh to create image iot-mqtt-docker-image:0.0.1

If you want to delete this image, you can run the script delete_iot_mqtt_docker_image.sh 

## Setup the EMQTT cluster

To setup a mqtt cluster we decide to use the feature emqtt because it is open-source and has more functionnalities than others (see https://github.com/mqtt/mqtt.github.io/wiki/server-support)

On two terminals run the scripts run_emqtt_container_node_1.sh and run_emqtt_container_node_2.sh. Two containers should be named s1-emqtt-io and s2-emqtt-io.

Then on each container

	cd /home
	sh modify_emq_conf_file.sh

Check that the file /etc/emqttd/emq.conf has been changed at the end.

	emqttd start
	emqttd_ctl cluster status

## Test the EMQTT cluster with mosquitto

Mosquitto is an open-source project that enables to publish and subscriber to any mqtt cluster.

on s1-emqtt-io

	mosquitto_sub -h s2-emqtt-io -t iot_data

on s2-emqtt-io
	
	mosquitto_pub -h s1-emqtt-io -t iot_data -m "Hello IoT"

You should see the message "Hello IoT" display on s1-emqtt-io

## Setup publisher and subscriber

On two terminals, execute run_publisher_container.sh and run_subscriber_container.sh. Two containers should be named publisher and subscriber.

On publisher

	cd /home
	sh publisher.sh tcp://s2-emqtt-io:1883 iot_data_test

On subscriber

	cd /home
	/usr/share/elasticsearch/bin/elasticsearch &
	sh subscriber.sh tcp://s1-emqtt-io:1883 iot_data_test persisters_configuration_file.json

## Kibana

on subscriber

	/usr/share/kibana/bin/kibana &
	
On your local desktop, open a browser and go to 

	192.168.1.21:5601


