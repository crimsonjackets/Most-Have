define(function(require) {
  // docs: ./docs/js/utils/simple_template.md
  var Stream = require('./stream')

  compile_template.stream = function(str) {
    var names = [].slice.call(arguments, 1)
      , stream = new Stream(Stream.READABLE | Stream.WRITABLE)
      , tpl = this(str)

    stream.write = function() {
      var args = arguments
        , ctxt = names
            .map(function(n, x) { return [n, args[x]] })
            .reduce(function(l, r) {
              l[r[0]] = r[1]
              return l
            }, {})

      stream.emit('data', tpl(ctxt))
    }

    stream.end = function() {
      stream.emit('end')
    }

    return stream
  }

  return compile_template

  function compile_template(str) {
    var rex = /\{\{(.*?)\}\}/
      , bits = []
      , match

    while(match = rex.exec(str)) {
      bits.push(Function('x', 'return x').bind(null, str.slice(0, match.index)))
      bits.push(Function('context', 'with(context) { return '+match[1].trim()+' }'))
      str = str.slice(match.index + match[0].length)

    }
    if(str.length)
      bits.push(Function('x', 'return x').bind(null, str))

    return render_template.bind(null, bits)
  }

  function render_template(pieces, context) {
    return pieces
      .map(render_piece)
      .join('')

    function render_piece(piece) {
      try {
        return piece(context)
      } catch(err) {
        throw err
      }
    }
  }
})
