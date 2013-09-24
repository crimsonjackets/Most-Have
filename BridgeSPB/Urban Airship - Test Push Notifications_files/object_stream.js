define(function(require) {
  var Stream = require('../utils/stream')

  function ObjectStream() {
    Stream.call(this, Stream.READABLE | Stream.WRITABLE)
  }

  var cons = ObjectStream
    , proto = cons.prototype = new Stream

  proto.constructor = cons

  proto.write = function(obj) {
    for(var key in obj) 
      this.emit('data', key, obj[key])
  }

  return cons
})
