define(function(require) {
  var EE = require('../utils/eventemitter')

  function Popover(content_template, cls) {
    this.el = $('<div class="'+(cls || 'popover')+'"></div>').hide().appendTo('body').css('position', 'absolute')
    this.content_template = content_template
    this._cached_contents = null
    this._is_open_on = null

    this.el.css({
      top:'-9999px'
    , left:'-9999px'
    }).show()

    $(document).click(this.click_document.bind(this))

    cons.popovers.push(this)

    if(cons.popovers.length === 1)
      cons.add_resize_listener()

    EE.call(this)
  }

  var cons = Popover
    , proto = cons.prototype = new EE

  proto.constructor = cons

  cons.popovers = []

  cons.add_resize_listener = function() {
    var self = this

    $(window).resize(function(ev) {
      self.popovers.forEach(function(popover) {
        if(popover.visible()) {
          var opts = $.extend(popover._options, {rerender:false})
          popover.open(popover._is_open_on, opts)
        }
      })
    })
  }

  proto.ATTACH_TOP = 0
  proto.ATTACH_BOTTOM = 1
  proto.ATTACH_LEFT = 2
  proto.ATTACH_RIGHT = 3

  proto.click_document = function(ev) {
    if(!this.visible()) 
      return

    var target = $(ev.target)
      , parents = target.parents()
      , should_hide = false
      , modal_el = this.el.get()[0]
      , open_on_el = this._is_open_on.get()[0]
      , chain = parents.get().concat(target.get())

    if(ev.target === open_on_el)
      return

    should_hide = !chain.some(function(el) {
      return el === modal_el || el === open_on_el 
    })

    // jquery+svg doesn't return all of the parents, apparently.
    // good job, svg.
    should_hide = should_hide && !target.is('path,g') 

    if(should_hide) {
      this.emit('hide')
      this.hide()
    }
  }

  proto.render = function(context, ready) {
    var self = this

    context = context || {}
    self.content_template.render(context, function(err, html) {
      if(err)
        return ready(err)

      self._cached_contents = $(html)
      self.el.html('').append(self._cached_contents)

      ready(null, self._cached_contents)
    })
  }

  proto.open = function(attach_to_el, options, ready) {
    options = $.extend({
      rerender: true
    , nib: true
    , attach: cons.ATTACH_BOTTOM
    , context: {}
    }, options)

    var self = this
      , is_fixed = false

    is_fixed = attach_to_el.parents().add(attach_to_el).get().some(function(el) {
      return $(el).css('position') === 'fixed'
    })

    self._is_open_on = attach_to_el
    self._options = options

    if(!self._cached_contents || options.rerender) {
      self.render(options.context, function(err) {
        if(err) throw err

        

        rendered()
      }) 
    } else {
      rendered()
    }

    return self


    function rendered() {
      self.el.css('position', is_fixed ? 'fixed' : 'absolute')
      var offs = is_fixed ? {top: 0, left: 0} : attach_to_el.offset()
        , bound_0 = [ offs.left, offs.top ]
        , bound_1 = [ bound_0[0] + attach_to_el.outerWidth(), bound_0[1] + attach_to_el.outerHeight() ]
        , our_bounds = [ self.el.outerWidth(), self.el.outerHeight() ]
        , attach_to_middle = (self.el.outerWidth()-attach_to_el.outerWidth())/2
        , target

      switch(options.attach) {
        default:
        case self.ATTACH_BOTTOM:
          target = [ (bound_1[0] - our_bounds[0]), bound_1[1] ]
          break
        case self.ATTACH_TOP:
          target = [ (bound_1[0] + bound_0[0]) / 2, bound_0[1] - our_bounds[1] ]
          break
        case self.ATTACH_LEFT:
          target = [ bound_0[0] - our_bounds[0], (bound_1[1] + bound_0[1]) / 2 ]
          break
        case self.ATTACH_SIDE:
          target = [ bound_1[0], (bound_1[1] + bound_0[1]) / 2 ]
          break
      }



      var left = ~~(bound_0[0]-attach_to_middle)
        , top = ~~(bound_1[1]+5)

      left = Math.max(0, left)
      top = Math.max(0, top)
      left = Math.min(window.innerWidth, left)
      top = Math.min(window.innerWidth, top)

      self.el
          .css({'left': left+'px', 'top': top+'px'})
          .show()

      if(ready) {
        ready()
      }
    }
  }

  proto.hide = function() {
    this.el.css({
      top:'-9999px'
    , left:'-9999px'
    }).show()

    this._is_open_on = null
  }

  proto.visible = function() {
    return !!this._is_open_on
  }

  return cons
})
