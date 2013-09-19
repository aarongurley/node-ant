###
# Example of how to use this module.
#
# Required:
# A USB Ant stick (V3 is provided with the Vector Pedals, V2 can be purchased online and changed to GarminStick2 below)
###

# A USB Ant stick is required
Stick = require('./node-ant').GarminStick3

# A type of sensor is required to read from
Sensor = require('./node-ant').VectorSensor

# Create an instance of the stick and open it for communication
# NOTE: you must have the USB stick inserted or a libusb error will be thrown
stick = new Stick();
stick.open();

# Create an instance of the sensor
vector = new Sensor(stick);

# Listen for data on that sensor
vector.on 'powerdata', (data)=>
  console.log(data.power.instantaneous)

# Initiate the Ant communicaiton with the sensor.
# This method requires 1) A channel number and 2) A device ID (normally 5 digits, shown as 4 here without the leading 0)
vector.attach(0, 5800)

# For this example, a timeout period is defined (5 seconds),
# and then all communication is severed.
setTimeout ((data) ->
  vector.detachAll()
), 5000