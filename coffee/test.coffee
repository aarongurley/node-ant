Stick = require('./node-ant').GarminStick3
Sensor = require('./node-ant').VectorSensor

stick = new Stick();
stick.open();

vector = new Sensor(stick);
vector.on 'powerdata', (data)=>
  console.log(data.power.instantaneous)
  
vector.attach(0, 5800)

#vector.detachAll();

setTimeout ((data) ->
  vector.detachAll()
), 5000