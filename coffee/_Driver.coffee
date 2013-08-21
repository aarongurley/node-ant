usb = require('usb')

class Driver
  constructor:()->
    usb.setDebugLevel(0)
    @rawStart = [
      'A4014A00EF',
      'A4024D0054BF',
      'A4094600B9A521FBBD72C34564',
      'A40342000000E5',
      'A4055100624D7901A7',
      'A4024400FF1D',
      'A4034300961F6D',
      'A402450039DA',
      'A4014B00EE'
      ]
    @rawStop = [
      'A4014C00E9',
      'A4014100E4',
      'A4014A00EF'
      ]
  open:()=>
    console.log 'This driver does not the open command'
    
  close:()=>
    console.log 'This driver does not the close command'




class USB2Driver extends Driver
  constructor:(idVendor,idProduct)->
    super()
    @device = usb.findByIds(idVendor, idProduct);
    @device.open();
    @iface = @device.interfaces[0];
    @iface.claim();
    @inEndpoint = @iface.endpoints[0];
    @inEndpoint.startStream(1, 64);
    
    @inEndpoint.on 'data', (d)=>
      console.log 'RECIEVE:', d
    @inEndpoint.on 'error', (e)=>
      console.log e
    @inEndpoint.on 'end', ()=>
      console.log '*****STOP RECIEVING*****'
    
    @outEndpoint = @iface.endpoints[1];
    #@writeStart(@outEndpoint);
  
  
  open:()=>
    console.log 'working'
    
  writeStart:(enpoint)=>
    for value in @rawStart
      buffer = new Buffer(value, 'hex')
      enpoint.transfer(buffer, @callbackWriteToOutPoint)
      console.log('WRITE:', buffer)
      
  writeStop:(enpoint)=>
    for value in @rawStop
      buffer = new Buffer(value, 'hex')
      enpoint.transfer(buffer, @callbackWriteToOutPoint)
      console.log('WRITE:', buffer)
    
  callbackWriteToOutPoint:(error)=>
    console.log(error) if error
