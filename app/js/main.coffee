global.document = window.document
app = require("./js/app")
MainLayouter = require("./js/views/main_layouter")
Chromecast = require("./js/chromecast")
require('backbone').$ = require("jquery")

app.isPlaying = false
app.isCasting = false
app.isCasting = false


chromecast = new Chromecast()
mainLayouter = new MainLayouter()
document.body.appendChild(mainLayouter.render().el)

console.log("nodewebkit version: ", process.versions['node-webkit'])
