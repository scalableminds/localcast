global.document = window.document
app = require("./js/app")
gui = require("nw.gui")
MainLayouter = require("./js/views/main_layouter")
Chromecast = require("./js/chromecast")
require('backbone').$ = require("jquery")

chromecast = new Chromecast()
mainLayouter = new MainLayouter()
document.body.appendChild(mainLayouter.render().el)

console.log("nodewebkit version: ", process.versions['node-webkit'])

win = gui.Window.get()
win.on("close", ->
  chromecast.disconnect()
  @close(true)
)

