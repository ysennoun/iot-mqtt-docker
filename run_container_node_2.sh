#!/bin/sh
# -----------------------------------------------------------------------------
# Script bash to create docker container for iot-mqtt project
# Author: Yassir Sennoun
# -----------------------------------------------------------------------------

docker run --net iot-mqtt-network --hostname s2-emqtt-io --add-host s1-emqtt-io:192.168.1.10 --ip 192.168.1.11 -it iot-mqtt-docker-image:0.0.1 bash

