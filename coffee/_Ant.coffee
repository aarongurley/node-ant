class Ant extends Constants
  constructor:()->
    super()
    @Driver                       = Driver
    @USB2Driver                   = USB2Driver
    @GarminStick2                 = GarminStick2
    @GarminStick3                 = GarminStick3
    
    @Messages                     = Messages
    @Sensor                       = Sensor
    @PowerSensor                  = PowerSensor
    @VectorSensor                 = VectorSensor
    @SpeedAndCadenceSensor        = SpeedAndCadenceSensor
    @GarminSpeedAndCadenceSensor  = GarminSpeedAndCadenceSensor