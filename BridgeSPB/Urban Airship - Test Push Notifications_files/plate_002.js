define({
  load:function(name, req, load, config) {
    var a = document.createElement('a')
    a.href = config.baseUrl
    if(a.host && a.host !== location.host) {
      req([name.replace(/\.html$/g, '')], function(str) {
        load(new plate.Template(str))
      })
    } else {
      req(['plugins/text!'+name], function(value) {
        load(new plate.Template(value))
      })
    }
  }
})
