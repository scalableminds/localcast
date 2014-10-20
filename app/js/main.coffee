global.document = window.document
gui = require("nw.gui")
app = require("./js/app")
MainLayouter = require("./js/views/main_layouter")
Chromecast = require("./js/chromecast")
ffmpeg = require("fluent-ffmpeg")
require('backbone').$ = require("jquery")

ffmpeg.getAvailableCodecs( (err, codecs) ->
  unless err #"Cannot find ffmpeg"
    app.hasFFmpegSupport = true
)

chromecast = new Chromecast()
mainLayouter = new MainLayouter()
document.body.appendChild(mainLayouter.render().el)

console.log("nodewebkit version: ", process.versions['node-webkit'])

win = gui.Window.get()
win.on("close", ->
  chromecast.disconnect()
  @close(true)
)

process.on("uncaughtException", (err) ->
  debugger
  console.error(err)
)
