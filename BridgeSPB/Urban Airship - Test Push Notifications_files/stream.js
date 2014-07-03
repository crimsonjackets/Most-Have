define(function(require) {
  var EE = require('./eventemitter')

  function Stream(flags) {
    this._writable = !!(flags & Stream.WRITABLE)
    this._readable = !!(flags & Stream.READABLE) 
    this.paused = false
    EE.call(this)
  }

  Stream.READABLE = 0x1
  Stream.WRITABLE = 0x2

  var cons = Stream
    , proto = cons.prototype = new EE

  var NotImplemented = function() {
    throw new Error('not implemented')
  }

  proto.constructor = cons

  proto.readable = function() {
    return this._readable
  }

  proto.writable = function() {
    return this._writable
  }

  proto.pipe = function(dst, options) {
    var src = this
      , did_on_end = false

    src.on('data', on_data)

    if(!options || !options.end) {
      src.on('end', on_end)
         .on('close', on_close)
    }

    dst.on('drain', on_drain)

    src.on('error', on_error)
    dst.on('error', on_error)

    return dst

    function on_data(/* args */) {
      if(dst.writable()) {
        if(dst.write.apply(dst, arguments) === false && src.pause !== NotImplemented) {
          src.pause()
        }
      }      
    }

    function on_drain() {
      if(src.readable() && src.resume)
        src.resume()
    }

    function on_end() {
      if(did_on_end)
        return

      did_on_end = true
      cleanup()

      dst.end()      
    }

    function on_close() {
      if(did_on_end)
        return

      did_on_end = true
      cleanup()
      dst.destroy()
    }

    function on_error(err) {
      cleanup()
    }

    function cleanup() {
      src.removeListener('data', on_data)
      dst.removeListener('drain', on_drain)

      src.removeListener('end', on_end)
      src.removeListener('close', on_close)

      src.removeListener('error', on_error)
      dst.removeListener('error', on_error)

      src.removeListener('end', cleanup)
      src.removeListener('close', cleanup)

      dst.removeListener('end', cleanup)
      dst.removeListener('close', cleanup)
    }
  }

  proto.pause = function() {
    this.paused = true
  }

  proto.resume = function() {
    this.paused = false
    this.emit('drain')
  }

  proto.destroy =
  proto.write =
  proto.read = NotImplemented 

  return cons
})
