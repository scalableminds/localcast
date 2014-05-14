_ = require("lodash")
Marionette = require("backbone.marionette")
PlaylistView = require("./playlist_view")
PlayerControlsView = require("./player_controls_view")
DragDropView = require("./drag_drop_view")
PlaylistCollection = require("../models/playlist_collection")

module.exports = class MainLayouter extends Marionette.Layout

  template : _.template("""
    <section class="content-container"></section>
    <section class="navbar-bottom"></section>
  """)

  className : "container vbox"
  # tagName : "body"

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

    @playlistCollection = new PlaylistCollection()
    @playlistView = new PlaylistView(collection : @playlistCollection)

    @listenTo(@, "render", @showRegions)


  showRegions : ->

    @sectionContent.show(@dragDropView)
    @sectionControls.show(@playerControlsView)


  fileDrop : (evt) =>

    evt.preventDefault()

    files = evt.originalEvent.dataTransfer.files

    _.map(files, (file) =>
      @playlistCollection.add(
        file,
        validate : true
      )
    )

    @sectionContent.show(@playlistView)



