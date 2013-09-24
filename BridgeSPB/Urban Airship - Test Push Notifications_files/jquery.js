define(function(require) {
  var Stream = require('../utils/stream')
    , inputstream = require('../widgets/inputstream')

  function JQStream() {
    Stream.call(this, Stream.READABLE | Stream.WRITABLE)
  }

  JQStream.prototype = new Stream

  JQStream.prototype.write = function(data) {
    this.emit('data', $(data))
    return this.paused
  }

  JQStream.prototype.end = function() {
    this.emit('end')
  }

  $.stream = function() {
    return new JQStream()
  }


  $.fn.removeListener = function() {

  }

  $.fn.stream = function(filter, keydown, add_on_change) {
    // turn an element (or elements) into a stream.
    // this means that when they change (or keyup),
    // they emit 'data' events.
    return inputstream(this, filter, keydown, add_on_change)
  } 

  $.fn.append_stream = function() {
    var stream = new JQStream()
      , self = $(this)

    stream.write = function(input) {
      self.append(input) 
      stream.emit('data', input)
    }

    return stream
  }

  $.fn.write = function(what) {
    // this makes it possible for
    // an element to be `pipe`'d to.
    // 
    //    var input = $('input')
    //      , output = $('pre')
    //
    //    input.stream().pipe(output)
    //
    //    // now any changes to input will be immediately
    //    // reflected in output
    //

    var self = $(this)

    self.html('')
        .append(what)

    self.trigger('data', self.children())
  }

  $.write = function(data) {
    data = $(data)
    $.emit('data', data)
  }

  $.fn.pause =
  $.fn.resume = function() { }

  $.fn.writable =
  $.fn.readable = function() { return true }
})
