global.document = window.document
Chromecast = require("./js/chromecast")
MainLayouter = require("./js/views/main_layouter")
app = require("./js/app")
require('backbone').$ = require("jquery")

app.isPlaying = false
app.isCasting = false
app.isCasting = false


chromecast = new Chromecast()
mainLayouter = new MainLayouter()
document.body.appendChild(mainLayouter.render().el)
