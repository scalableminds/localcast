global.document = window.document
Chromecast = require("./js/chromecast.js")
MainLayouter = require("./js/views/main_layouter.js")
require('backbone').$ = require("jquery")


chromecast = new Chromecast()
mainLayouter = new MainLayouter()
document.body.appendChild(mainLayouter.render().el)
