#!/bin/sh
# -----------------------------------------------------------------------------
# Script bash to run Mqtt publisher
# Author: Yassir Sennoun
# -----------------------------------------------------------------------------

# Arguments

syntax="INVALID ARGUMENTS: publisher.sh <MQTT SERVER URI> <TOPIC_NAME>"
[ "$#" -ne 2 ] && echo $syntax && exit 1;
serverUri=$1
topic=$2

echo "
ServerURI --> $serverUri
TopicName --> $topic
"

# run publisher

java -cp jars/iot-mqtt-1.0-SNAPSHOT-jar-with-dependencies.jar com.xebia.iot.main.PublisherMain ${serverUri} ${topic}

