class SpeedAndCadenceSensor extends Sensor
  constructor:(stick)->
    super(stick)
  
  attach:(channel, deviceID)=>
    super(channel, 'receive', deviceID, 121, 1, 255, 8086, 57)




class GarminSpeedAndCadenceSensor extends SpeedAndCadenceSensor
  constructor:(stick)->
    super(stick)
  
  attach:(channel, deviceID)=>
    super(channel, deviceID)