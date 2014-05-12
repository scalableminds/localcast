global.document = window.document
global.$ = require("jquery")
global.jQuery = require("jquery")
global.Backbone = require("backbone")

console.log(Backbone.$)

$ = require("jquery")
MainLayouter = require("./js/views/main_layouter.js")


mainLayouter = new MainLayouter()
$("body").html(mainLayouter.render().el)
