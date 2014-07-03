define(function(require) {
  var Stream = require('../utils/stream')

  return through

  function through(write, end) {
    write = write || default_write
    end = end || default_end

    var ended = false
      , destroyed = false
      , buffer = []
      , stream = new Stream(Stream.READABLE | Stream.WRITABLE)

    stream.paused = false

    stream.write = function(data) {
      write.call(stream, data)
      return !stream.paused
    }

    stream.queue = function(data) {
      buffer.push(data)
      drain()
      return stream
    }

    stream.end = function(data) {
      if(ended) return

      ended = true

      if(arguments.length) stream.write(data)
      _end()

      return stream
    }

    stream.destroy = function() {
      if(destroyed) return

      destroyed = ended = true

      buffer.length = 0
      stream.readable = stream.writable = false
      stream.emit('close')
      return stream
    }

    stream.pause = function() {
      if(stream.paused) return

      stream.paused = true
      stream.emit('pause')
      return stream
    }

    stream.resume = function() {
      stream.paused = false
      drain()

      if(!stream.paused)
        stream.emit('drain')
      return stream
    }

    stream.on('end', function() {
      stream.readable = false
      if(!stream.writable) {
        setTimeout(function() {
          stream.destroy()
        }, 0)
      }
    })

    return stream

    function drain() {
      var data
      while(buffer.length && !stream.paused) {
        data = buffer.shift()
        if(null === data)
          return stream.emit('end')
        stream.emit('data', data)
      }
    }

    function _end() {
      stream.writable = false
      end.call(stream)
      if(!stream.readable)
        stream.destroy()
    }
  }

  function default_write(data) {
    this.queue(data)
  }

  function default_end(data) {
    this.queue(null)
  }
})
