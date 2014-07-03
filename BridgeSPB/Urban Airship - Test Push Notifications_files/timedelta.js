define(function(require) {
  // docs: ./docs/js/utils/timedelta.md

  function TimeDelta(offsets) {
    offsets = offsets || {}
    this.offset = typeof offsets === 'object' ? Object.keys(offsets)
      .reduce(function(lhs, rhs) {
        return lhs + offsets[rhs] * (cons.units[rhs] || 0)
      }, 0) : offsets
  }

  var cons = TimeDelta
    , proto = cons.prototype

  function Unit(name, ms) {
    this.ms   = ms
    this.name = name
  }

  Unit.prototype.valueOf = function() {
    return this.ms 
  }

  cons.Unit = Unit
  cons.units = {}
  cons.units.milliseconds = new Unit('millisecond', 1)
  cons.units.seconds      = new Unit('second',  1000)
  cons.units.minutes      = new Unit('minute',  60 * cons.units.seconds)
  cons.units.hours        = new Unit('hour',    60 * cons.units.minutes)
  cons.units.days         = new Unit('day',     24 * cons.units.hours)
  cons.units.weeks        = new Unit('week',    7  * cons.units.days)
  cons.units.years        = new Unit('year',    52 * cons.units.weeks)

  // create a sorted list of units, smallest to largest.
  cons.sorted_units = Object.keys(cons.units).map(function(name) {
    return cons.units[name]
  }).sort(function(lhs, rhs) {
    if(lhs.ms < rhs.ms) return -1
    if(lhs.ms > rhs.ms) return 1
    return 0 
  }).reverse()

  proto.valueOf = function() {
    return this.offset
  }

  proto.stringify = function(ignore) {
    var result
      , offset = this.offset
      , NotApplicable = new Object
    
    ignore = ignore || []

    return cons.sorted_units
      .map(map_units)
      .filter(filter_applicable)
      .join(', ')

    function map_units(unit) {
      if(!!~ignore.indexOf(unit.name) || !!~ignore.indexOf(unit.name+'s'))
        return NotApplicable

      if(offset < 1)
        return NotApplicable

      result = offset / unit

      if(result < 1)
        return NotApplicable 

      result = ~~result
      offset -= result * unit

      return result + ' ' + (result === 1 ? unit.name : unit.name+'s')
    }

    function filter_applicable(item) {
      return item !== NotApplicable
    }
  }

  return cons
})
