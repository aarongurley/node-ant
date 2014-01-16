usb = require('usb')

class Driver extends Constants
  constructor:()->
    usb.setDebugLevel(0)
  open:()=>
    console.log 'This driver does not the open command'
    
  close:()=>
    console.log 'This driver does not the close command'




class USB2Driver extends Driver
  constructor:(@idVendor, @idProduct)->
    super()
    @device       = null
    @iface        = null
    @inEndpoint   = null
    @outEndpoint  = null
    
  open:()=>
    @device = usb.findByIds(@idVendor, @idProduct);
    @device.open();
    @iface = @device.interfaces[0];
    @iface.claim();
    @inEndpoint = @iface.endpoints[0];
    @inEndpoint.startStream(1, 128);
    
    @inEndpoint.on 'data', (d)=>
      #console.log 'RECIEVE:', d
      this.emit('read', d)
    @inEndpoint.on 'error', (e)=>
      console.log e
    @inEndpoint.on 'end', ()=>
      console.log '*****STOP RECIEVING*****'
    
    @outEndpoint = @iface.endpoints[1];
    #@writeStart(@outEndpoint);
  
  close:()=>
  
  write:(buffer)=>
    @outEndpoint.transfer(buffer, @writeCallback)
    
  writeCallback:(error)=>
    console.log(error) if error
    
  # writeStart:(enpoint)=>
  #   for value in @rawStart
  #     buffer = new Buffer(value, 'hex')
  #     enpoint.transfer(buffer, @callbackWriteToOutPoint)
  #     console.log('WRITE:', buffer)
  #     
  # writeStop:(enpoint)=>
  #   for value in @rawStop
  #     buffer = new Buffer(value, 'hex')
  #     enpoint.transfer(buffer, @callbackWriteToOutPoint)
  #     console.log('WRITE:', buffer)
    

