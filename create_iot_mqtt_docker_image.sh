#!/bin/sh
# -----------------------------------------------------------------------------
# Script bash to create docker image for iot-mqtt project
# Author: Yassir Sennoun
# -----------------------------------------------------------------------------

cmd=$(docker images | grep iot-mqtt-docker-image:0.0.1)
[ -z "${cmd}" ] && echo "Image already created"
[ -z "${cmd}" ] && docker build -tag iot-mqtt-docker-image:0.0.1 docker-files/. && echo "Image created"



