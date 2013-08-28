class Sensor extends Messages
  constructor:(@stick)->
    super()
  
  attach:(channel, type, deviceID, deviceType, transmissionType, timeout, period, frequency)=>
    @stick.write(@resetSystem())
    @stick.write(@requestMessage(channel))
    @stick.write(@setNetworkKey())
    @stick.write(@assignChannel(channel, type))
    @stick.write(@setDevice(channel, deviceID, deviceType, transmissionType))
    @stick.write(@searchChannel(channel, timeout))
    @stick.write(@setPeriod(channel, period))
    @stick.write(@setFrequency(channel, frequency))
    @stick.write(@openChannel(channel))
  
  detachAll:(channel)=>
    @stick.write(@closeChannel(channel))
    @stick.write(@unassignChannel(channel))
    @stick.write(@resetSystem())