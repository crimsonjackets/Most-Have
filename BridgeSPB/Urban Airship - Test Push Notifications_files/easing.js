define(function(require) {
  var sin   = Math.sin.bind(Math)
    , H_PI  = Math.PI/2
    , EE    = require('../utils/eventemitter')

  function Easing(target, initial) {
    this.initial  = initial || 0
    this.target   = target
    this.elapsed  = 0
    this.duration = 1000
  }

  var cons = Easing
    , proto = cons.prototype

  proto.ease = function() {
    return this.initial + (this.target - this.initial) * sin(this.elapsed/this.duration * H_PI)
  }

  proto.start = function(duration) {
    this.duration = duration || this.duration

    var ee    = new EE
      , now   = new Date
      , self  = this
      , dt
      , tmp

    setTimeout(iter, 0)

    return ee

    function iter() {
      tmp = new Date
      dt = tmp - now
      now = tmp
      self.elapsed += dt
      if(self.elapsed < self.duration) {
        ee.emit('data', self.ease())
        setTimeout(iter, 0) 
      } else {
        ee.emit('end',  self.target)
        ee.remove('data')
        ee.remove('end')
      }
    }
  }

  function ease(from, to, duration) {
    var easing = new Easing(to, from)
    return easing.start(duration)
  }
  ease.Easing = Easing

  return ease
})
