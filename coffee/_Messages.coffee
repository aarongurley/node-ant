class Messages extends Constants
  constructor:()->
    super()
    
  resetSystem:()=>
    payload = []
    payload.push 0x00
    return @buildMessage payload, @MESSAGE_SYSTEM_RESET
  
  
  ### Attachment methods ###
  requestMessage:(channel=0)=>
    payload = []
    payload = payload.concat(@intToLEHexArray(channel))
    payload.push @MESSAGE_CAPABILITIES #TODO: this is the Message Requested ID (might need to change based on device type, not sure)
    return @buildMessage payload, @MESSAGE_CHANNEL_REQUEST
  
  setNetworkKey:()=>    
    payload = []
    payload.push @DEFAULT_NETWORK_NUMBER
    payload.push 0xB9
    payload.push 0xA5
    payload.push 0x21
    payload.push 0xFB
    payload.push 0xBD
    payload.push 0x72
    payload.push 0xC3
    payload.push 0x45
    return @buildMessage payload, @MESSAGE_NETWORK_KEY
  
  assignChannel:(channel=0,type='receive')=>
    payload = []
    payload = payload.concat(@intToLEHexArray(channel))
    if type is 'receive'
      payload.push @CHANNEL_TYPE_TWOWAY_RECEIVE
    else
      payload.push @CHANNEL_TYPE_TWOWAY_TRANSMIT
    payload.push @DEFAULT_NETWORK_NUMBER
    return @buildMessage payload, @MESSAGE_CHANNEL_ASSIGN
  
  setDevice:(channel=0, deviceID=0, deviceType=0, transmissionType=0)=>
    payload = []
    payload = payload.concat(@intToLEHexArray(channel))
    payload = payload.concat(@intToLEHexArray(deviceID))
    payload = payload.concat(@intToLEHexArray(deviceType))
    payload = payload.concat(@intToLEHexArray(transmissionType))
    return @buildMessage payload, @MESSAGE_CHANNEL_ID
  
  searchChannel:(channel=0, timeout=0)=>
    payload = []
    payload = payload.concat(@intToLEHexArray(channel))
    payload = payload.concat(@intToLEHexArray(timeout))
    return @buildMessage payload, @MESSAGE_CHANNEL_SEARCH_TIMEOUT
  
  setPeriod:(channel=0, period=0)=>
    payload = []
    payload = payload.concat(@intToLEHexArray(channel))
    payload = payload.concat(@intToLEHexArray(period))
    return @buildMessage payload, @MESSAGE_CHANNEL_PERIOD
  
  setFrequency:(channel=0, frequency=0)=>
    payload = []
    payload = payload.concat(@intToLEHexArray(channel))
    payload = payload.concat(@intToLEHexArray(frequency))
    return @buildMessage payload, @MESSAGE_CHANNEL_FREQUENCY
  
  openChannel:(channel=0)=>
    payload = []
    payload = payload.concat(@intToLEHexArray(channel))
    return @buildMessage payload, @MESSAGE_CHANNEL_OPEN


  ### Detachment methods ###
  
  closeChannel:(channel=0)=>
    payload = []
    payload = payload.concat(@intToLEHexArray(channel))
    return @buildMessage payload, @MESSAGE_CHANNEL_CLOSE
  
  unassignChannel:(channel=0)=>
    payload = []
    payload = payload.concat(@intToLEHexArray(channel))
    return @buildMessage payload, @MESSAGE_CHANNEL_UNASSIGN
  
    
  ###
  #
  # @description    Builds the entire message to send to the ant device
  # @param          payload = Array, An array of bytes
  # @param          msgID = Byte, A single byte representing the message ID
  # @returns        Buffer, a byte buffer to be sent to the ant device
  #
  ###
  
  buildMessage:(payload = [], msgID = 0x00)=>
    m = []
    m.push @MESSAGE_TX_SYNC
    m.push payload.length
    m.push msgID
    for byte in payload
      m.push byte
    m.push @getChecksum(m)
    return new Buffer(m)
  
  intToLEHexArray:(int)=>
    a = []
    #b = new Buffer(int.toString(16), 'hex')
    b = new Buffer(@decimalToHex(int), 'hex')
    i = b.length - 1
    while i >= 0
      a.push b[i]
      i--
    return a
    
  decimalToHex:(d, padding)=>
    hex = Number(d).toString(16)
    padding = (if typeof (padding) is "undefined" or padding is null then padding = 2 else padding)
    hex = "0" + hex  while hex.length < padding
    return hex
  
  getChecksum:(message)=>
    for byte in message
      checksum = (checksum ^ byte) % 0xFF
    return checksum
      