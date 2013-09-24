define(function(require) {
  function Parser(content) {
    this.content = content
    this.output = {}
    this.idx = 0

    this.current_link = null
    this.current_attrs = {}
  }

  var cons = Parser
    , proto = cons.prototype

  proto.get = function() {
    return this.content.charAt(this.idx++)
  }

  proto.parse_link = function(end) {
    var link = []
      , c

    do {
      c = this.get()

      if(c === end) 
        break

      link.push(c)
    } while(this.idx < this.content.length)

    return link
  }

  proto.parse_attr = function() {
    var attr = []
      , value = []
      , current = attr
      , done = false
      , c

    do {
      c = this.get()
      switch(true) {
        case /[\w\d\-_]/.test(c): current.push(c); break
        case /=/.test(c): current = value; break
        case /["'<]/.test(c): {
          current
              .splice
              .apply(
                  current
                , [0, current.length]
                  .concat(this.parse_link(c === '<' ? '>' : c))
              )
          } break
        case /[;,]/.test(c): --this.idx; done = true; break 
      }
    } while(!done && this.idx < this.content.length)

    this.current_attrs[attr.join('')] = value.join('')
  }

  proto.accumulate = function() {
    this.output[this.current_attrs.rel] = this.current_attrs
    this.current_attrs.href = this.current_link

    this.current_link = null
    this.current_attrs = {}
  }

  proto.parse = function() {
    var c

    do {
      c = this.get()
      switch(c) {
        case '<': this.current_link = this.parse_link('>').join(''); break
        case ';': this.parse_attr(); break
        case ',': this.accumulate(); break
      }

    } while(this.idx < this.content.length)

    this.accumulate()

    return this.output
  }

  return function(content) {
    return new Parser(content).parse()
  }
})
