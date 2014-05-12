global.document = window.document
# window._ = global._ = require("lodash")._
# window.$ = global.$ = require("jquery")
# window.jQuery = global.jQuery = require("jquery")
require('backbone').$ = require("jquery")
# require('backbone.marionette').Backbone.$ = require("jquery")


$ = require("jquery")
MainLayouter = require("./js/views/main_layouter.js")

$ ->
mainLayouter = new MainLayouter()
document.body.appendChild(mainLayouter.render().el)
