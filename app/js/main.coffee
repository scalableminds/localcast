require [
  "jquery",
  "app",
  "views/main_layouter"
], ($, app, MainLayouter) ->

  mainLayouter = new MainLayouter()
  $("body").html(mainLayouter.render().el)
