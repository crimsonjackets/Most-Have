define(function(require) {

  return function(module_name, version, strategy) {
    // example prefix: "stats@0.0.1"
    var new_prefix = module_name+'@'+version

    // we store current version by module name: "stats" -> "0.0.1"
    // so we can short-circuit early.
    if(localStorage.getItem(module_name) === version) {
      return new_prefix
    }

    // matches key:, key@N.N.N
    var rex = new RegExp('^'+module_name+'(@([^:]+))?:')
      , match

    // apps may provice a strategy to migrate the data from
    // the current version to the latest version, but we default
    // to just blowing away the data.
    strategy = strategy || function(key, current_version, target) {
    }

    // this sort of sucks.
    for(var key in localStorage) {
      match = rex.exec(key)

      if(!match) {
        continue
      }

      if(match[2] !== version) {
        value = strategy(key, match[2], version)

        // remove the old key.
        localStorage.removeItem(key)

        // if we get a new value, set the new key.
        if(value !== undefined) {
          localStorage.setItem([new_prefix].concat(key.split(':').slice(1)).join(':'), value)
        }
      }
    }

    // set the new module version.
    localStorage.setItem(module_name, version)

    return new_prefix
  }
})
