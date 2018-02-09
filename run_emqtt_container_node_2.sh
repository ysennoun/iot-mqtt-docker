#!/bin/sh
# -----------------------------------------------------------------------------
# Script bash to create docker container for iot-mqtt project
# Author: Yassir Sennoun
# -----------------------------------------------------------------------------

cmd=$(docker network list | grep iot-mqtt-network)
[ -z "${cmd}" ] && docker network create --subnet=192.168.1.0/16 iot-mqtt-network && "Docker network iot-mqtt-network created"

docker run --net iot-mqtt-network --hostname s2-emqtt-io --add-host s1-emqtt-io:192.168.1.10 --ip 192.168.1.11 -it iot-mqtt-docker-image:0.0.1 bash

