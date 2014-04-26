require [
  "app"
  "views/main_layouter"
], (app, MainLayouter) ->

  new MainLayouter(el : document.body)
