define(function(require) {
  require('./jquery.stream')

  var Autocomplete = require('../widgets/autocomplete')
    , url_template = $('[data-app-search-url]').attr('data-app-search-url')
    , result_template = require('plugins/plate!templates/includes/app_search_results.html') 
    , content_template = require('plugins/plate!templates/includes/app_search.html') 
    , format = require('../utils/simple_template')
    , Popover = require('../widgets/popover')
    , populated = false
    , autocomplete
    , search_el
    , has_apps
    , popover
    , target
    , opts
    , el

  has_apps = !!url_template
  popover = new Popover(content_template)
  opts = {rerender: false}

  $('body').on('click', 'li > [rel=app-search]', function(ev) {
    ev.preventDefault()
    el = $(this)
    el.addClass('active')
    popover.open(el, opts)
    popover.el.find('input').focus()
  })

  popover.on('hide', function() {
    el.removeClass('active') 
  })

  popover.render({has_apps: has_apps}, continue_search_setup)

  function continue_search_setup() {
    if(!has_apps) {
      return
    }

    search_el = popover.el.find('#appselect_search')
    target = popover.el.find('#id_menu_app_list')

    function mutate_data(apps, headers) {
      return [apps.objects, headers]
    }

    autocomplete = new Autocomplete(
        search_el
      , url_template
      , target
      , result_template
    )

    autocomplete.xhr_stream.write(format(url_template)({q: ''}))

    autocomplete.mutate_data = mutate_data
    autocomplete.on('open', function() {
      $(window).scroll()
    })

    autocomplete.init()
    
    $('.appselect_button').on('click', function() { $(window).scroll() })

    autocomplete.on('data', function(app) {
      if(!app) {
        return
      }

      window.location = app.url
    })
  }
})
