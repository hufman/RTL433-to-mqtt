# Config section
# Fill in the next 2 lines if your MQTT server expected authentication
import os
from os import environ

MQTT_USER=""
MQTT_PASS=""
MQTT_HOST="mqtt.example.com"
MQTT_PORT=1883
MQTT_TOPIC="sensors/rtl_433"
MQTT_QOS=0
DEBUG=False # Change to True to log all MQTT messages
# End config section

if "MQTT_USER" in os.environ:
    MQTT_USER = os.environ.get("MQTT_USER")

if "MQTT_PASS" in os.environ:
    MQTT_PASS = os.environ.get("MQTT_PASS")

if "MQTT_HOST" in os.environ:
    MQTT_HOST = os.environ.get("MQTT_HOST")

if "MQTT_PORT" in os.environ:
    MQTT_PORT = os.environ.get("MQTT_PORT")

if "MQTT_TOPIC" in os.environ:
    MQTT_TOPIC = os.environ.get("MQTT_TOPIC")

if "MQTT_QOS" in os.environ:
    MQTT_QOS = os.environ.get("MQTT_QOS")

if "DEBUG" in os.environ:
    DEBUG = os.environ.get("DEBUG")
