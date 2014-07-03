define(function(require) {
  var request = require('../modules/request')
    , scroll = require('../widgets/scroll')
    , tpl = require('plugins/plate!templates/error_list.html')

  var body = $(document.body)
    , error_console = $('.error-console')
    , target
    , tbody
    , url

  url = error_console.attr('data-endpoint')
  target = error_console.find('.target')
  tbody = target.find('tbody')

  body.on('fetch', function(ev) {
    target.addClass('loading')
  })

  body.on('click', '[rel=clear-errors]', function(ev) {
    ev.preventDefault()
    request('DELETE', url, function() {
      tbody.html('<tr>No errors.</tr>')
    })
  })

  if(error_console.length) {
    scroll(target, url, tpl, 10) 
      .on('data', target.removeClass.bind(target, 'loading'))
      .pipe(tbody.append_stream())
  }

  body.removeClass('preload')

  body.on('click', '[rel="nav-toggle"]', toggle_nav)
      .on('click', '[rel="console-toggle"]', toggle_console)
      .on('click', '[rel="info-toggle"]', toggle_info)

  function toggle_nav(ev) {
    ev.preventDefault()

    var classes = ['sidebar-on', 'sidebar-off']
    if(!body.is('.sidebar-on')) {
      classes = classes.reverse()
    }
    body.removeClass(classes[0])
        .addClass(classes[1])
  }

  function toggle_console(ev) {
    ev.preventDefault()

    if(body.is('.console-on')) {
      body.removeClass('console-on info-on')
          .addClass('console-off')
    } else {
      if(!tbody.children('*').length) {
        target.trigger({type: 'empty'})
      }

      body.removeClass('console-off info-on')
          .addClass('console-on')
    }
  }

  function toggle_info(ev) {
    ev.preventDefault()

    if(body.is('.info-on')) {
      body.removeClass('console-on info-on')
          .addClass('info-off')
    } else {
      body.removeClass('console-on info-off')
          .addClass('info-on')
    }
  }

})
