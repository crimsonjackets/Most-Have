define(function(require) {
  var Stream = require('../utils/stream')

  return function(el, filter, keydown, add_on_change) {
    var stream = new Stream(Stream.READABLE)
      , paused = false

    add_on_change = add_on_change === undefined ? true : add_on_change

    filter = filter || function(k) { return true }

    stream.pause = function() { paused = true }
    stream.resume = function() { paused = false } 

    el = $(el)

    if(!el.is('form')) {
      el.keyup(function(ev) {
        if(filter(ev.keyCode, ev))
        if(!paused)
          stream.emit('data', $(ev.target).val())
      })

      if(add_on_change)
        el.change(function(ev) {
          var val

          if(el.is('[type=checkbox]')) {
            if(el.length > 1) {
              val = el.filter(function(idx, e) {
                return $(e).is(':checked')
              }).get().map(function(e) {
                return $(e).val()
              })
            } else {
              val = el.is(':checked')
            } 
          } else {
            val = $(ev.target).val()
          }

          if(!paused)
            stream.emit('data', val)
        })

      if(keydown)
        el.keydown(keydown)

    }

    if(el.is('form')) {
      el.submit(function(ev) {
        ev.preventDefault()
        stream.emit('data', el.serializeArray().reduce(function(lhs, rhs) {
          lhs[rhs.name] = rhs.value
          return lhs    
        }, {}))
      })
    }

    return stream
  }
})
