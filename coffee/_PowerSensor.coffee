class PowerSensor extends Sensor
  constructor:(@stick)->
    super(@stick)
    @stick.on 'read', @handleDataDecode
  
  attach:(channel, deviceID)=>
    super(channel, 'receive', deviceID, 11, 5, 255, 8182, 57)
  
  handleDataDecode:(data)=>
    if data.readUInt8(1) >= 8 && data.readUInt8(2) == @MESSAGE_CHANNEL_BROADCAST_DATA
      
      switch data.readUInt8(4)
        when @POWER_PAGE_STANDARD_POWER_ONLY
          json = @getPowerOnlyData data
          this.emit 'powerdata', json
        #when @POWER_PAGE_BATTERY_VOLTAGE
          #json.messagetype.name = 'batteryvoltage'
        #when @POWER_PAGE_CALIBRATION_REQUEST
          #json.messagetype.name = 'calibrationrequest'
        #else
          #json.messagetype.name = null



  getPowerOnlyData:(data)=>
    json = {}
    json.messagetype = {
      name:       'power',
      pagenumber: data.readUInt8(4)
    }
    
    json.eventcount = data.readUInt8(5)

    json.balance = {}
    if data.readUInt8(6) >> 7 & 1
      json.balance.side = 'right'
      json.balance.value = data.readUInt8(6) ^ 0x80
    else
      json.balance.side = 'unknown'
      json.balance.value = data.readUInt8(6)
    json.balance.unit = {
      long:   'Percent',
      short:  '%'
    }
    
    json.cadence = {}
    switch data.readUInt8(7)
      when 0xFF
        json.cadence.value = null
      else
        json.cadence.value = data.readUInt8(7)
    
    json.cadence.unit = {
      long:   'Revolutions Per Minute',
      short:  'RPM'
    }
    
    json.power = {
      accumulated:    data.readUInt16LE(8),
      instantaneous:  data.readUInt16LE(10),
      unit:           {
        long:   'Watt',
        short:  'W'
      }
    }
    
    return json




class VectorSensor extends PowerSensor
  constructor:(@stick)->
    super(@stick)
  
  attach:(channel, deviceID)=>
    super(channel, deviceID)