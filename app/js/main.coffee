require [
  "app"
  "main_layouter"
], (app, MainLayouter) ->

  new MainLayouter(el : document.body)
