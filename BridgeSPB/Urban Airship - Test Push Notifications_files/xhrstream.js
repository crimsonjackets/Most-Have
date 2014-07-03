define(function(require) {
  var Stream = require('../utils/stream')
    , debounce = require('../utils/debounce')

  function XHRStream(request, method, path, headers, body) {
    this.request = request
    this.method = method
    this.path = path
    this.headers = headers
    this.body = body

    this._debounce_ms = 0

    Stream.call(this, Stream.READABLE | Stream.WRITABLE)
  }

  var cons = XHRStream
    , proto = cons.prototype = new Stream

  proto.constructor = cons

  proto.set_debounce_ms = function(ms) {
    this._debounce_ms = ms
  }

  proto.write = function() {
    if(this.xhr) return false

    var args = this.get_args([].slice.call(arguments))
      , on_write = this.get_on_write()

    on_write(args)
  }

  proto.get_args = function(args) {
    var count = 0
      , our_args = [
            this.method
          , this.path
          , this.headers
          , this.body
        ]
  
    for(var i = 0, len = our_args.length; i < len; ++i) {
      if(our_args[i] === undefined) {
        our_args[i] = args[count++]
      }
    }

    return our_args
  }

  proto.get_on_write = function() {
    this._on_write = this._on_write || debounce(this.start_xhr.bind(this), this._debounce_ms) 
    return this._on_write 
  }

  proto.start_xhr = function(args) {
    var self = this

    self.emit('request', args)
    self.xhr = self.request.apply(null, args.concat([onready]))

    function onready(err, data, headers) {
      if(err) return self.emit('error', err)

      delete self.xhr

      self.emit('data', data, headers)
      self.emit('drain')
    }
  }

  return cons
})
