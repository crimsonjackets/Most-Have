define(function(require) {
  // docs: ./docs/js/utils/qs.md

  function qs(obj) {
    return Object.keys(obj)
      .reduce(function(lhs, rhs) {
        if(Array.isArray(obj[rhs])) {
          obj[rhs].forEach(function(value) {
            lhs[lhs.length] = [rhs, value]
          })
        } else {
          lhs[lhs.length] = [rhs, obj[rhs]]
        }
        return lhs
      }, [])
      .map(function(keypair) {
        return [encodeURIComponent(keypair[0]), encodeURIComponent(keypair[1])].join('=')
      })
      .join('&')
  }

  return qs
})
