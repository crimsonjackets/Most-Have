define(function(require) {
  var ArrayStream = require('../modules/array_stream')
    , ObjectStream = require('../modules/object_stream')

  Array.stream = function() { return new ArrayStream() }
  Object.stream = function() { return new ObjectStream() }
})
