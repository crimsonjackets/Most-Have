define(function(require) {
  var request = require('../modules/request')
    , debounce = require('../utils/debounce')
    , EE = require('../utils/eventemitter')
    , TimeDelta = require('../utils/timedelta')
    , qs = require('../utils/qs')
    , addcommas = require('../utils/addcommas')

  var migrate = require('../modules/migrations')

  var fetch_data = debounce(fetch_visible)
    , PREFIX_KEY = migrate('stats', '0.0.1')
    , templates = {}
    , stats_elements

  templates.devices = new plate.Template(
    '{{ ios|add:android|addcommas }} '+
    '<span class="platforms">'+
    'iOS: <span class="num">{{ ios|addcommas }}</span> '+
    'Android: <span class="num">{{ android|addcommas }}</span></span>'
  )

  templates.device_tokens = new plate.Template(
    '{{ device_tokens|addcommas }} '+
    'Active: <span class="num">{{ active_device_tokens|addcommas }}</span>'
  )

  templates.pushes = new plate.Template(
    '{{ pushes|addcommas }}'
  )

  templates.downloads = new plate.Template(
    'Free downloads: '+
    '<span class="num">{{ free|addcommas }}</span>, '+
    'Purchases: <span class="num">{{ purchases|addcommas }}</span>'
  )

  templates.subscriptions = new plate.Template(
    '{{ ios|add:android|addcommas }} '+
    'iOS: <span class="num">{{ ios|addcommas }}</span> '+
    'Android: <span class="num">{{ android|addcommas }}</span>'
  )

  $(window)
    .bind('scroll', fetch_data)
    .bind('scroll', fetch_data)

  fetch_data()

  function fetch_visible() {
    var scrollY = window.scrollY !== undefined ? window.scrollY : document.body.scrollTop
      , bottom = $(window).height()

    stats_elements = $('.app_counts_ajax:visible:not(.populated)').filter(visible(scrollY, scrollY + bottom))

    for(var i = 0, len = stats_elements.length; i < len; ++i) {
      fetch(stats_elements.eq(i))
    }
  }

  function visible(top, bottom) {
    return function(idx, el) {
      el = $(el)
      
      var offset = el.offset()

      return offset.top >= top && offset.top <= bottom
    }
  }

  function fetch(el) {
    var key = el.attr('data-key')
      , last_month = el.attr('data-last-month')
      , type = el.attr('data-type')

    el.addClass('populated')

    load_data([key, type, last_month], function(err, html) {
      if(err) {
        return el.text('Data temporarily unavailable')
      }

      el.html(html)
      store_data([key, type, last_month], html)
    })
  }

  function load_data(key_bits, ready) {
    key_bits.unshift(PREFIX_KEY)

    var key = key_bits.join(':')
      , data = load_data.cache[key]
      , now = Date.now()
      , ee


    if(data && data.once) {
      return data.once('ready', ready)
    }

    if(data) {
      return ready(null, data)
    }

    data = JSON.parse(localStorage.getItem(key) || 'false')

    if(data && data.timeout > now) {
      return ready(null, data.html)
    }

    // uh oh
    ee = new EE

    load_data.cache[key] = ee

    request.get('/apps/ajax_totals/?'+qs({
        key: key_bits[1]
      , type: key_bits[2]
      , last_month: key_bits[3] || ''
    }), got_data) 

    function got_data(err, data) {
      templates[key_bits[2]].render(data, function(err, data) {
        ee.emit('ready', err, data)
        ready(err, data)
      })
    }
  }

  load_data.cache = {}

  function store_data(key_bits, data) {
    key_bits.unshift(PREFIX_KEY)

    var key = key_bits.join(':')

    load_data.cache[key] = data

    localStorage.setItem(key, JSON.stringify({timeout: Date.now() + new TimeDelta({hours:1}), html: data}))
  }
})
