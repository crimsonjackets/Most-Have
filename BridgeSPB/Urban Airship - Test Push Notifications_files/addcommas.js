define(function(require) {

  function addcommas(num) {
    var rgx = /(\d+)(\d{3})/
      , num_split
      , num_split_1
      , num_split_2

    num += ''
    num_split = num.split('.')
    num_split_1 = num_split[0]
    num_split_2 = num_split.length > 1 ? '.' + num_split[1] : ''

    while (rgx.test(num_split_1)) {
      num_split_1 = num_split_1.replace(rgx, '$1,$2')
    }

    return num_split_1 + num_split_2
  }

  plate.Template.Meta.registerFilter('addcommas', function(input) {
    return addcommas(+input)
  })

  return addcommas
})
