Marionette = require("backbone.marionette")
_ = require("lodash")
$ = require("jquery")

module.exports = class DragDropView extends Marionette.ItemView

  template : _.template("""
    <div>
      <span class="fa fa-4x fa-copy"></span>
      <p>Drag and Drop some media files to start</p>
    </div>
  """)

  className : "drag-drop hbox flex-center full-height"


  initialize : ->

    $(window).on(
      dragover : @fileHover.bind(@)
      dragend :  @fileDragEnd.bind(@)
    )


  fileHover : ->

    @$el.addClass("hover")


  fileDragEnd : ->

    @$el.removeClass("hover")


  onClose : ->

    # remove drag & drop handlers
