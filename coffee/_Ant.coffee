class Ant extends Constants
  constructor:()->
    super()
    @stick = null
  
  init:()=>
    
  selectStick:(stickName)=>
    switch stickName
      when 'Garmin2'
        @stick = new USB2Driver(0x0fcf, 0x1008)
      when 'Garmin3'
        @stick = new USB2Driver(0x0fcf, 0x1009)
