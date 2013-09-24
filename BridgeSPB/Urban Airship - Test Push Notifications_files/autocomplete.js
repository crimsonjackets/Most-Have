define(function(require) {
  var template = require('../utils/simple_template')
    , linkparse = require('../utils/linkparse')
    , request = require('../modules/request')
    , Stream = require('../utils/stream')

  function AutoComplete(el, url_template, target, result_template, xhrstream) {
    this.url_template_stream = template.stream(url_template, 'q') 
    this.xhr_stream = xhrstream || request.get(undefined, {}, null)
    this.xhr_stream.set_debounce_ms(1000)

    this.result_template = result_template || new plate.Template(this.base_template)
    this.el = $(el)

    this.target = target

    this.headers = null
    this.data = null

    Stream.call(this, Stream.READABLE)
  }

  var cons = AutoComplete
    , proto = cons.prototype = new Stream(Stream.READABLE)

  proto.base_template = [
      '{% for item in items %}'
    , '<li><a href="#" rel="item">{{ item }}</a></li>'
    , '{% endfor %}'
  ].join('')

  proto.unwrap = function(data) {
    return data
  }

  proto.mutate_data = function() {
    return [].slice.call(arguments)
  }

  proto.init = function() {
    var self = this

    self.el.stream(self.catch_keys.bind(self), self.keydown.bind(self), false)
        .pipe(self.url_template_stream)
        .pipe(self.xhr_stream)
          .on('drain',  xhr_on_drain)
          .on('data',   xhr_on_data)
          .mutate('data', self.mutate_data)
        .pipe(self.result_template.stream('items'))
        .pipe(self.target)
          .on('data',   target_on_data)

    self.el.blur(self.emit.bind(self, 'hide'))

    self.target.click(function(ev) {
      var target = $(ev.target)
        , parent

      if(target.is('[rel=item]') || target.parents('[rel=item]').length) {
        ev.preventDefault()
        ev.stopPropagation()

        while(target.length) {
          if(target.parent().is('[name=container]')) {
            break
          }
          target = target.parent()
        }

        target = self.data[target.prevAll().length]

        if(target) {
          self.emit('data', target)
        }
      }
    })

    function xhr_on_drain() {
      self.el.removeClass('loading')
    }

    function xhr_on_data(data, headers) {
      self.data = self.unwrap(data)
      self.headers = headers
    }

    function target_on_data(ev) {
      if(self.data.length > 0) {
        return self.emit('open')
      }

      self.emit('hide')
    }
  }

  proto.catch_keys = function(key, ev) {
    var chr = String.fromCharCode(key)
    if(/[^\w\d\-:]/.test(chr) && key !== 8) {
      return false
    }

    if(!$(ev.target).val().length) {
      this.emit('hide')
      return false
    }

    this.el.addClass('loading')

    return true
  }

  // catch "space", "tab", "enter", and arrow keys
  proto.keydown = function(ev) {
    var self = this
      , container = self.target

    if(!!~[39, 40].indexOf(ev.keyCode) && !ev.shiftKey) {
      down()
    } else if(!!~[37, 38].indexOf(ev.keyCode)) {
      up()
    } else if(!!~[32, 9].indexOf(ev.keyCode) && ev.shiftKey) {
      up()
    } else if(!!~[32, 9].indexOf(ev.keyCode)) {
      down()
    } else if(ev.keyCode === 13) {
      select()
    }

    return

    function select() {
      ev.preventDefault()
      var target = container.find('.highlight')

      if(self.data.length === 1)
        target = container.children().eq(0)

      if(!target.length)
        target = container.find(':first-child')

      self.emit('data', self.data[target.prevAll().length])
      self.emit('hide')
    }

    function up() {
      ev.preventDefault()
      var target = container.find('.highlight')
        , prev = target.prev()

      if(!target.length || !prev.length) {
        // load previous page
        load('prev')
      } else {
        target.removeClass('highlight')
        prev.addClass('highlight')
      }
    }

    function down() {
      ev.preventDefault()
      var target = container.find('.highlight')
        , next = target.next()


      if(!target.length) {
        container.children().eq(0).addClass('highlight')
      } else if(!next.length) {
        // load next page
        load('next')
      } else {
        target.removeClass('highlight')
        next.addClass('highlight')
      }
    }

    function load(key) {
      if(!self.headers)
        return

      var parsed = linkparse(self.headers.link || '')

      if(!parsed || !parsed[key]) {
        return
      }

      self.el.addClass('loading')
      self.url_template_stream.emit('data', parsed[key].href)
    }
  }

  return cons
})
