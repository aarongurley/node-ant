class Sensor extends Messages
  constructor:(@stick)->
    super()
    @stick.on 'read', @handleEventMessages
  
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
  
  handleEventMessages:(data)=>    
    if(data.readUInt8(2) == @MESSAGE_CHANNEL_EVENT)
      if data.length == 7
        @emitStatus data
      else
        for i in [0...data.length] by 7
          @emitStatus new Buffer([data[i], data[i+1], data[i+2], data[i+3], data[i+4], data[i+5], data[i+6]], 'hex')
      
  
  emitStatus:(data)=>
    messageID = data.readUInt8(2)
    
    if messageID is @MESSAGE_CHANNEL_EVENT
      status = {
        desc:null,
        value:null
      }
    
      switch data.readUInt8(4)
        when @MESSAGE_NETWORK_KEY
          status.desc   = 'network key set'
          status.value  = true
        when @MESSAGE_CHANNEL_ID
          status.desc   = 'channel ID set'
          status.value  = true
        when @MESSAGE_CHANNEL_SEARCH_TIMEOUT
          status.desc   = 'search timeout set'
          status.value  = true
        when @MESSAGE_CHANNEL_PERIOD
          status.desc   = 'channel period set'
          status.value  = true
        when @MESSAGE_CHANNEL_FREQUENCY
          status.desc   = 'frequency set'
          status.value  = true
        when @MESSAGE_CHANNEL_OPEN
          status.desc   = 'channel opened'
          status.value  = true
        when @MESSAGE_CHANNEL_CLOSE
          status.desc   = 'channel closed'
          status.value  = true
        when @MESSAGE_CHANNEL_UNASSIGN
          status.desc   = 'channel unassigned'
          status.value  = true
    
      this.emit 'status', status
          