## Test mosquitto

on s1-emqtt-io

	mosquitto_sub -h 192.168.1.11 -t iot_data

on s2-emqtt-io
	
	mosquitto_pub -h 192.168.1.10 -t iot_data -m "Hello IoT"
