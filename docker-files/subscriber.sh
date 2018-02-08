#!/bin/sh
# -----------------------------------------------------------------------------
# Script bash to run Mqtt subscriber
# Author: Yassir Sennoun
# -----------------------------------------------------------------------------

# Arguments

syntax="INVALID ARGUMENTS: publisher.sh <MQTT SERVER URI> <TOPIC_NAME> <CONFIGURATION_FILE_PATH>"
[ "$#" -ne 3 ] && echo $syntax && exit 1;
serverUri=$1
topic=$2
configFilePath=$3

echo "
ServerURI      --> $serverUri
TopicName      --> $topic
ConifgFilePath --> $configFilePath
"

# run publisher

java -cp jar/iot-mqtt-1.0-SNAPSHOT-jar-with-dependencies.jar com.xebia.iot.main.SubscriberMain ${serverUri} ${topic} ${configFilePath}
