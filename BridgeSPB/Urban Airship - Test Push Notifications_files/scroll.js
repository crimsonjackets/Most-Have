define(function(require) {
  var through = require('../modules/through-stream')
    , request = require('../modules/request')
    , linkparse = require('../utils/linkparse')

  return function scroll(el, url, tpl, buf) {
    var input = through()
      , stream = through(write)
      , output = tpl.stream('items')
      , xhr = request.get()
      , in_flight = false
      , inner_height
      , outer_height
      , container
      , scroll_el
      , raw_el
      , ret

    output.on('data', function(data) {
      stream.queue(data)
    })

    stream.url = function(u) {
      return url = u || url
    }

    stream.trigger = function() {
      input.queue(url)
    }

    el.parents().get().some(function(el) {
      scroll_el = container = $(raw_el = el)
      return container.css('overflow') === 'auto'
    })

    if(!container || container.is('html')) {
      container = $(document.body)
      raw_el = document.body
      scroll_el = $(window)
    }

    buf = buf || 200

    scroll_el.on('scroll', function(ev) {
      var last
        , st

      inner_height = el.height()
      outer_height = container.height()

      if(!url || in_flight) {
        return
      }

      // so, well-behaved (webkit) browsers will
      // have the scrollTop where we expect it to be.
      // IE/FF will not; hence the "walk up the parents
      // and see where the scrollTop isn't zero" song
      // and dance.
      st = el.parents().filter(function(i, x) {
        return x.scrollTop !== 0
      }).get()[0]

      // oh, but to start with nothing has a scrollTop by
      // that definition. so, we use what we were expecting
      // to use in the beginning. fun fact, this means it's
      // just going to be zero.
      st = st ? st.scrollTop : 0

      // are we way away from the edge?
      if(inner_height - (st + outer_height) >= buf) {
        return
      }

      if(last === null) {
        return
      }

      last = url
      in_flight = !(url = null)
      input.queue(last)
    })

    el.on('empty', function(ev) {
      ev.preventDefault()

      if(!url) {
        return
      }
      input.queue(url)
    })

    input 
      .pipe(xhr)
        .on('request', emit_fetch)
        .on('data', set_next_url)
      .pipe(through(timestamp_to_date))
      .pipe(output) 
        .on('data', function() { in_flight = false }) 

    return stream

    function write(data) {
      input.write(data)
    }

    function emit_fetch(url) {
      el.trigger({type: 'fetch', url: url})
    }

    function set_next_url(data, headers) {
      var parsed = linkparse(headers.link || headers.Link || '')
      url = (parsed.next || {}).href || null
    }

    function timestamp_to_date(data) {
      if(!data.objects) {
        return this.queue(data)
      }
      for(var i = 0, len = data.objects.length; i < len; ++i) {
        data.objects[i].timestamp = new Date(data.objects[i].timestamp * 1000)
      }
      return this.queue(data)
    }
  }
})
