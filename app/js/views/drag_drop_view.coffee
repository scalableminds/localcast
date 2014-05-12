Marionette = require("backbone.marionette")

module.exports = class DragDropView extends Backbone.Marionette.ItemView

  template : _.template("""
    <div>
      <span class="fa fa-4x fa-copy"></span>
      <p>Drag and Drop some media files to start</p>
    </div>
  """)

  className : "drag-drop hbox flex-center full-height"


  initialize : ->

    $(window).on(
      dragover : _.bind(@fileHover, @)
      dragend : _.bind(@fileDragEnd, @)
    )


  fileHover : ->

    @$el.addClass("hover")


  fileDragEnd : ->

    @$el.removeClass("hover")


  onClose : ->

    # remove drag & drop handlers
