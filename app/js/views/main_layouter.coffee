define [
  "backbone.marionette",
  "./playlist_view",
  "./player_controls_view",
  "./drag_drop_view",
  "models/playlist_collection"
], (Marionette, PlaylistView, PlayerControlsView, DragDropView, PlaylistCollection) ->

  class MainLayouter extends Backbone.Marionette.Layout

    template : _.template("""
      <section class="content-container"></section>
      <section class="navbar-bottom"></section>
    """)

    className : "container vbox"
    tagName : "body"

    regions :
      "sectionContent" : ".content-container"
      "sectionControls" : ".navbar-bottom"

    events :
      "drop" : "fileDrop"


    initialize : ->

      # prevent default behavior from changing page on dropped file
      window.ondrop = (evt) -> evt.preventDefault(); return false
      window.ondragover = (evt) -> evt.preventDefault(); return false

      @playerControlsView = new PlayerControlsView()
      @dragDropView = new DragDropView()

      @listenTo(@, "render", @showRegions)


    showRegions : ->

      @sectionContent.show(@dragDropView)
      @sectionControls.show(@playerControlsView)


    fileDrop : (evt) ->

      evt.preventDefault()

      files = evt.originalEvent.dataTransfer.files

      playlistCollection = new PlaylistCollection(
        _.map(files, (file) -> return file),
        validate : true
      )
      playlistView = new PlaylistView(collection : playlistCollection)

      @sectionContent.show(playlistView)



