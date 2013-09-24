define(function(require) {
  var Popover = require('../widgets/popover')
    , template = new plate.Template('<div class="help-text">{{ help_text }}</div>')
    , popover = new Popover(template, 'popover tooltip')
    , open_options = {}
    , is_listening = false

  $('body')
    .on('mouseenter', '[data-help]', show_tooltip)
    .on('mouseleave', '[data-help]', hide_tooltip)

  function show_tooltip(ev) {
    // make sure our element is always last.
    popover.el.appendTo('body')

    var el = $(this)
      , text = el.attr('data-help')

    open_options.context = {help_text: text}

    popover.open(el, open_options)

    setTimeout(function() {
      is_listening = true
    }, 500)
  }

  function hide_tooltip(ev) {
    if(!is_listening)
      return

    is_listening = false

    popover.hide()
  }
})
