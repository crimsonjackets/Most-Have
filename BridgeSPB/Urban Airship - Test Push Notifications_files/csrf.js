define(function(require) {
  var cookie = require('../utils/cookie')

  function same_origin(url) {
    var host = window.location.host
      , protocol = window.location.protocol
      , sr_origin = '//'+host
      , origin = protocol+sr_origin

    var is_origin = url === origin || url.slice(0, origin.length+1) === origin+'/'
      , is_sr_origin = url === sr_origin || url.slice(0, sr_origin.length+1) === sr_origin+'/'
      , not_sr_or_scheme = !/^(\/\/|http:|https:).*/.test(url)
 
    return is_origin || is_sr_origin || not_sr_or_scheme 
  }

  function safe_method(method) {
    return !!~safe_method.methods.indexOf(method)
  }

  safe_method.methods = [
      'GET'
    , 'HEAD'
    , 'OPTIONS'
    , 'TRACE'
  ]

  $(document).ajaxSend(function(event, xhr, settings) {
    var add_csrf = !safe_method(settings.type) && same_origin(settings.url)

    if(add_csrf) {
      xhr.setRequestHeader('X-CSRFToken', cookie('csrftoken'))
    }
  })
})
