require.config(

  baseUrl : "/js"

  waitSeconds : 0

  paths :
    "jquery"              : "../bower_components/jquery/dist/jquery"
    "underscore"          : "../bower_components/lodash/dist/lodash"
    "bootstrap"           : "../bower_components/bootstrap/dist/js/bootstrap"
    "backbone.marionette" : "../bower_components/marionette/lib/backbone.marionette"
    "backbone"            : "../bower_components/backbone/backbone"

  shim :
    "underscore" :
      exports : "_"
    "bootstrap" : [ "jquery" ]
    "backbone" :
      deps : [ "jquery", "underscore" ]
      exports : "Backbone"
    "backbone.marionette" : [ "backbone", "underscore" ]

)
