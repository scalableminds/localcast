Marionette = require("backbone.marionette")
Marionette.$ = require("jquery")
console.log(Marionette.$)

app = new Marionette.Application()

module.exports = app
