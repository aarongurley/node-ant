class GarminStick2 extends USB2Driver
  constructor:()->
    super(0x0fcf, 0x1008)

class GarminStick3 extends USB2Driver
  constructor:()->
    super(0x0fcf, 0x1009)