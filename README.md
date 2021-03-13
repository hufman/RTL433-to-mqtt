# RTL_433 to MQTT gateway

Lightweight docker container built on Ubuntu 18:04 that uses python3, rtl_433, rtls_sdr, and paho_mqtt
Using the well known rtl_433 software and an inexpensive RTL-SDR receiver it will listen to a variety 
of devices transmitting at the 433.92 Mhz frequency and publish the data to an MQTT broker.


## MQTT Topics
The gateway will receive information from the SDR receiver and publish them in JSON format to the topic
`sensors/rtl_433`. (by default)

Subtopics are created from this JSON line allowing easy subscribtion to specific sensors.

Testing can be done with the following command:

```bash
mosquitto_sub -h mqtt.example.com -p 1883 -v -t "sensors/#"
```

This will generate output like this:

```
sensors/rtl_433 {"time" : "2018-07-05 09:48:17", "model" : "AlectoV1 Wind Sensor", "id" : 36, "channel" : 1, "battery" : "OK", "wind_speed" : 0.000, "wind_gust" : 0.200, "wind_direction" : 315, "mic" : "CHECKSUM"}

sensors/rtl_433/AlectoV1 Wind Sensor/time 2018-07-05 09:48:17
sensors/rtl_433/AlectoV1 Wind Sensor/id 36
sensors/rtl_433/AlectoV1 Wind Sensor/channel 1
sensors/rtl_433/AlectoV1 Wind Sensor/battery OK
sensors/rtl_433/AlectoV1 Wind Sensor/wind_speed 0.0
sensors/rtl_433/AlectoV1 Wind Sensor/wind_gust 0.2
sensors/rtl_433/AlectoV1 Wind Sensor/wind_direction 315
sensors/rtl_433/AlectoV1 Wind Sensor/mic CHECKSUM
sensors/rtl_433 {"time" : "2018-07-05 09:48:22", "model" : "AlectoV1 Rain Sensor", "id" : 140, "channel" : 0, "battery" : "OK", "rain_total" : 621.750, "mic" : "CHECKSUM"}
```

Note that spaces can be used in topic names!




## Pulling docker container from dockerhub
```bash
docker pull pcoiner/rtl433-to-mqtt:latest
```


## Starting with docker run

```bash
docker run -d --rm \
  --privileged \
  -v /dev/bus/usb:/dev/bus/usb \
  --env MQTT_HOST="mqtt.example.com" \   # Required
  --env MQTT_TOPIC="sensors/rtl_433" \   # Default="sensors/rtl_433"
  --env MQTT_PORT=1883 \                 # Default=1883
  --env MQTT_USER="" \                   # Not Required
  --env MQTT_PASS="" \                   # Not Required
  --env MQTT_QOS=0 \                     # Default=0
  --env RTL_OPTS="" \                    # Any extra rtl_433 options
  --env DEBUG=False \                    # Change to True to log all MQTT messages
  --name rtl433-to-mqtt \
  pcoiner/rtl433-to-mqtt:latest
```

## docker-compose.yaml
```bash

  rtl433-to-mqtt:
    container_name: rtl433-to-mqtt
    privileged: true
    image: pcoiner/rtl433-to-mqtt:latest
    environment:
      MQTT_HOST: 'mqtt.example.com'
#      MQTT_TOPIC: 'sensors/rtl_433'
#      MQTT_PORT: '1883'
#      MQTT_USER: ''
#      MQTT_PASS: ''
#      MQTT_QOS: '0'
#      RTL_OPTS: ''
#      DEBUG: 'False'
    devices:
      - /dev/bus/usb:/dev/bus/usb
    restart: always
```

## Building docker from source
```bash
git clone https://github.com/orrious/RTL433-to-mqtt.git
cd RTL433-to-mqtt
docker build -t rtl433-to-mqtt:latest .
```

This will build the image needed to start a container. When the build process is completed start the container: