Marionette = require("backbone.marionette")
Marionette.$ = require("jquery")

app = new Marionette.Application()

app.IDLE = 0
app.PLAYING = 1
app.PAUSED = 2
app.BUFFERING = 3

app.state = app.IDLE
app.isCasting = false

app.changeState = (state) ->
  app.state = state
  app.vent.trigger("app:stateChanged", app.state)

module.exports = app
