#
# Docker file to create an image that contains enough software to listen to events on the 433,92 Mhz band,
# filter these and publish them to a MQTT broker.
#
# The script resides in a volume and should be modified to meet your needs.
#
# The example script filters information from weather stations and publishes the information to topics that
# Domoticz listens on.
#
# Special attention is required to allow the container to access the USB device that is plugged into the host.
# The container needs priviliged access to /dev/bus/usb on the host.
#
## Starting with docker run
#
#docker run -d --rm \
#  --privileged \
#  -v /dev/bus/usb:/dev/bus/usb \
#  --env MQTT_HOST="mqtt.example.com" \   # Required
#  --env MQTT_TOPIC="sensors/rtl_433" \   # Default="sensors/rtl_433"
#  --env MQTT_PORT=1883 \                 # Default=1883
#  --env MQTT_USER="" \                   # Not Required
#  --env MQTT_PASS="" \                   # Not Required
#  --env MQTT_QOS=0 \                     # Default=0
#  --env DEBUG=False \                    # Change to True to log all MQTT messages
#  --name rtl433-to-mqtt \
#  pcoiner/rtl433-to-mqtt:latest


FROM ubuntu:18.04
MAINTAINER Paul Coiner

LABEL Description="This image is used to start a script that will monitor for events on 433,92 Mhz" Vendor="MarCoach" Version="1.0"


#
# First install software packages for rtl_433 and to publish MQTT events
#
RUN apt-get update && apt-get install -y \
	rtl-sdr \
	librtlsdr0 \
	python3-paho-mqtt

COPY rtl-433_20.02-1_amd64.deb /tmp/rtl-433_20.02-1_amd64.deb
RUN dpkg -i /tmp/rtl-433_20.02-1_amd64.deb

#
# Copy config, script and make it executable
#
COPY rtl2mqtt.py /scripts/rtl2mqtt.py
COPY config.py /scripts/config.py
RUN chmod +x /scripts/rtl2mqtt.py

#
# When running a container this script will be executed
#

ENTRYPOINT ["/scripts/rtl2mqtt.py"]
