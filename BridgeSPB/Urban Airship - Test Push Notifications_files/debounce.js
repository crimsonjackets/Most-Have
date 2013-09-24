define(function(require) {
  // docs: ./docs/js/utils/debounce.md

  return function(fn, ms) {
    var timeout
      , ms = ms || 0

    debounced.clear = clear

    return debounced

    function clear() {
      clearTimeout(timeout)
    }

    function debounced() {
      var self = this
        , args = [].slice.call(arguments)

      timeout && clearTimeout(timeout)
      timeout = setTimeout(call, ms)

      function call() {
        return fn.apply(self, args)
      }
    }
  }
})
