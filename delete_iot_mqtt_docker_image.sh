#!/bin/sh
# -----------------------------------------------------------------------------
# Script bash to delete docker image for iot-mqtt project
# Author: Yassir Sennoun
# -----------------------------------------------------------------------------

cmd=$(docker images | grep iot-mqtt-docker-image:0.0.1)
[ -z "${cmd}" ] && echo "Image already deleted"
[ ! -z "${cmd}" ] && docker rmi -f iot-mqtt-docker-image:0.0.1 && echo "Image deleted"




