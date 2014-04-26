define [
  "backbone.marionette",
  "./playlist_view",
  "models/playlist_collection"
], (Marionette, PlaylistView, PlaylistCollection) ->

  class MainLayouter extends Backbone.Marionette.Layout

    ui :
      "sectionDragDrop" : ".drag-drop"

    regions :
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

      files = evt.originalEvent.dataTransfer.files
      @$(".drag-drop").hide()

      playlistCollection = new PlaylistCollection(
        _.map(files, (file) -> return file),
        validate : true
      )
      playlistView = new PlaylistView(collection : playlistCollection)

      @sectionPlaylist.show(playlistView)


    fileHover : ->

      @ui.sectionDragDrop.addClass("hover")


    fileDragEnd : ->

      @ui.sectionDragDrop.removeClass("hover")

