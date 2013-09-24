define(function(require) {
  var PlatePromise = plate.utils.Promise

  plate.Template.Meta.registerPlugin(
      'loader'
    , function(template_name) {
        var p = new PlatePromise

        require(['plugins/plate!'+template_name], function(tpl) {
          setTimeout(function() { p.resolve(tpl) }, 0)
        })

        return p
      }
  )

  plate.Template.Meta.registerTag(
      'count'
    , count_to
  )

  var Stream = require('../utils/stream')
    , easing = require('../modules/easing')

  plate.Template.prototype.stream = function() {
    var names = [].slice.call(arguments)
      , stream = new Stream(Stream.READABLE | Stream.WRITABLE)
      , tpl = this

    stream.end = function() {
      stream.emit('end')
    }

    stream.write = function() {
      var args = arguments
        , ctxt = names
            .map(function(n, x) { return [n, args[x]] })
            .reduce(function(l, r) {
              l[r[0]] = r[1]
              return l
            }, {})

      tpl.render(ctxt, function(err, data) {
        if(err) return stream.emit('error', err)

        stream.emit('data', data)
      })
    }

    return stream
  }

  plate.stream = function(str) {
    var names = [].slice.call(arguments, 1)
      , tpl = new plate.Template(str)

    return tpl.stream.apply(tpl, names)
  }

  var COUNT_ID = 0

  function count_to(tokens, parser) {
    var bits = tokens.split(/\s+/)
      , from_idx = bits.indexOf('from')
      , to_idx = bits.indexOf('to')
      , in_idx = bits.indexOf('in')
      , as_idx = bits.indexOf('as')
      , _from
      , _to
      , _in
      , _as
      , nodes

    if(Math.min(from_idx, to_idx, in_idx, as_idx) < 0) {
      throw new Error('Missing one of `from`, `to`, `in`, or `as`.')
    }

    // {% count from {filter} to {filter} in N.ns %}
    // time is given in decimal seconds.
    _from = parser.compile(bits[from_idx + 1])
    _to = parser.compile(bits[to_idx + 1])
    _in = parseFloat(bits[in_idx + 1].replace(/[^\d\.]/g, '')) * 1000
    _as = bits[as_idx + 1]

    nodes = parser.parse(['endcount'])
    parser.tokens.shift()

    return {
      render: render
    }

    function render(context, from, to, nodelist) {
      var _id = 'plate-count-'+(COUNT_ID++)
        , interval
        , element
        , c

      from = from || _from.resolve(context)
      if(from && from.constructor === PlatePromise) {
        promise = new PlatePromise
        from.once('done', function(data) {
          promise.resolve(render(context, data))
        })
        return promise
      }

      to = to || _to.resolve(context)
      if(to && to.constructor === PlatePromise) {
        promise = new PlatePromise
        to.once('done', function(data) {
          promise.resolve(render(context, from, data))
        })
        return promise
      } 

      if(nodelist === undefined) {
        c = context.copy()
        c[_as] = from 
        nodelist = nodes.render(c)
      }

      if(nodelist && nodelist.constructor === PlatePromise) {
        nodelist.once('done', function(data) {
          promise.resolve(render(context, from, to, data))
        })
        return promise
      }

      interval = setInterval(wait, 33)
      return '<span id="'+_id+'">'+nodelist+'</span>'

      function wait() {
        if((element = document.getElementById(_id)) &&
          from !== undefined &&
          to !== undefined) {
          clearInterval(interval)
          countup()
          return
        }
      }

      function countup() {
        easing(+from, +to, +_in)
          .on('data', insert)
          .on('end', insert) 
      }

      function insert(data) {
        c[_as] = data

        var nodelist = nodes.render(c)

        if(nodelist && nodelist.constructor === PlatePromise) {
          nodelist.once('done', function(data) {
            element.innerHTML = html
          })
          return
        }
        element.innerHTML = nodelist
      }
    }
  }
})
