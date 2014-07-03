define(function(require) {
  var XHRStream = require('./xhrstream')
    , X_HTTP_OVERRIDE = { 'PUT': 'POST', 'DELETE': 'POST', 'HEAD':'GET', 'OPTIONS':'GET' }
    , qs = require('../utils/qs')
    , zones = []

  var make_xhr = function () {
    return new XMLHttpRequest
  }

  if(window.ActiveXObject) {
    make_xhr = function() {
      return new ActiveXObject('Microsoft.XMLHTTP')
    }
  }

  function to_header(key) {
    return key.split('-').map(function(chunk) {
      return chunk.charAt(0).toUpperCase() + chunk.slice(1) 
    }).join('-')
  }

  function parse_headers(response_headers) {
    response_headers =
    response_headers.split('\r\n')
                    .map(function(header) {
                      var bits = header.split(': ')
                        , header = bits[0]
                        , value = bits.slice(1).join(': ')

                      return [header, value]
                    })
                    .reduce(function(lhs, rhs) {
                      if(rhs[0].length) {
                        lhs[rhs[0]] = lhs[rhs[0]] ? [lhs[rhs[0]], rhs[1]].join(', ') : rhs[1]
                      }
                      return lhs
                    }, {})

    return response_headers
  }

  function request(method, path, headers, body, ready) {
    var xhr = new XMLHttpRequest
      , zone

    if(typeof headers === 'function') {
      ready = headers
      headers = {}
    } else if(typeof body === 'function') {
      ready = body
      body = null
    }

    headers = headers || {}
    headers['Accept'] = headers['Accept'] || 'application/json'
    if(X_HTTP_OVERRIDE[method]) {
      headers['X-HTTP-Method-Override'] = X_HTTP_OVERRIDE[method] 
    }

    // if you don't pass a ready function...
    if(!ready) {
      return new XHRStream(request, method, path, headers, body)
    }

    zone = zones.filter(function(zone) {
      return zone[0].test(path)
    })[0]

    if(zone && !('x-UA-keymaster-digest' in headers)) {
      return zone[1](function(err, data) {
        if(err)
          return ready(err)

        for(var key in data) {
          headers[key] = data[key]
        }

        return request(method, path, headers, body, ready)
      })
    }

    if(body && typeof body === 'object' && !headers['content-type']) {
      headers['content-type'] = 'application/json'
    }

    headers['x-requested-with'] = 'XMLHttpRequest'

    xhr.open(method, path)
    for(var key in headers)
      xhr.setRequestHeader(to_header(key), headers[key])

    xhr.timeout = 10000

    xhr.onreadystatechange = function() {
      if(xhr.readyState !== 4) {
        return
      }

      var parsed
        , response_headers

      try {
        if(xhr.status < 200 || xhr.status > 299) {
          throw new Error('xhr '+xhr.status+' '+xhr.responseText)
        }

        parsed = xhr.responseText
        response_headers = parse_headers(xhr.getAllResponseHeaders())

        if(/json/.test(xhr.getResponseHeader('Content-Type')))
          parsed = JSON.parse(xhr.responseText)

      } catch(e) {
        return ready(e)
      }

      ready(null, parsed, response_headers)
    }

    if(body) {
      if(typeof body === 'object')
        body = (headers['content-type'] === 'application/json') ? JSON.stringify(body) : qs(body)
    }
    xhr.send(body || null)
    return xhr 
  }

  ;['GET', 'POST', 'PUT', 'DELETE', 'HEAD', 'OPTIONS'].forEach(function(method) {
    request[method.toLowerCase()] = request.bind(null, method)
  })


  request.link = function(link) {
    return link.split(',')
        .map(function(relation) {
          return relation.split(/;\s*/)
        })
        .reduce(function(lhs, rhs) {
          var link = rhs[0].slice(1, -1)
            , rel = rhs[1].split('=')
          
          if(rel[0] === 'rel') {
            rel[1] = /['"]/.test(rel[1].charAt(0)) ? rel[1].slice(1, -1) : rel[1]

            lhs[rel[1]] = link
          }

          return lhs
        }, {})
  }

  request.protect = function(path_rex, with_zone) {
    zones.push([path_rex, with_zone])    
  }


  return request
})

