define(function(require) {
  var Stream = require('../utils/stream')

  function ArrayStream() {
    Stream.call(this, Stream.READABLE | Stream.WRITABLE)
  }

  var cons = ArrayStream
    , proto = cons.prototype = new Stream

  proto.constructor = cons

  proto.write = function(items) {
    for(var i = 0, len = items.length; i < len; ++i)
      this.emit('data', items[i])
  }

  return cons
})
