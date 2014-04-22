define [
  "backbone.marionette"
], (Marionette) ->

  class MainLayouter extends Backbone.Marionette.ItemView

    ui :
      "sectionPlaylist" : ".playlist"
      "sectionDragDrop" : ".drag-drop"

    events :
      "drop" : "fileDrop"
      "dragover" : "fileHover"
      "dragEnd" : "fileDragEnd"


    initialize : ->

      # prevent default behavior from changing page on dropped file
      window.ondragover = (evt) -> evt.preventDefault(); return false
      window.ondrop = (evt) -> evt.preventDefault(); return false

      @bindUIElements()


    fileDrop : (evt) ->

      evt.preventDefault()

      for file in evt.originalEvent.dataTransfer.files
        console.log file


    fileHover : ->

      @ui.sectionDragDrop.addClass("hover")


    fileDragEnd : ->

      @ui.sectionDragDrop.removeClass("hover")

