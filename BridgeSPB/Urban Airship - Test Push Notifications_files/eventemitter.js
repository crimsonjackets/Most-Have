define(function(require) {
  // docs: ./docs/js/utils/eventemitter.md

  function EventEmitter() {
    this._listeners = {}
    this._mutators = {}
  }

  var cons  = EventEmitter
    , proto = cons.prototype

  proto.on = function(ev, fn) {
    (this._listeners[ev] = this._listeners[ev] || []).push(fn)
    return this
  }

  proto.mutate = function(ev, fn) {
    this._mutators[ev] = fn
    return this
  }

  proto.once = function(ev, fn) {
    var self = this
    return self.on(ev, listener)

    function listener() {
      fn.apply(this, [].slice.call(arguments))

      self.removeListener(ev, listener)
    }
  }

  proto.emit = function(ev) {
    var list = (this._listeners[ev] || []).slice()
      , args = [].slice.call(arguments, 1)
      , mutator = this._mutators[ev] || function() { return [].slice.call(arguments) }

    args = mutator.apply(null, args)

    for(var i = 0, len = list.length; i < len; ++i) {
      list[i].apply(null, args)
    }
  } 

  proto.listeners = function(ev) {
    return this._listeners[ev] || []
  }

  proto.removeListener = 
  proto.remove = function(ev, fn) {
    var tmp = this._listeners[ev] || []

    typeof fn === 'function' ? 
      tmp.indexOf(fn) > -1 && tmp.splice(tmp.indexOf(fn), 1) :
      delete this._listeners[ev]
  }

  return EventEmitter
})
