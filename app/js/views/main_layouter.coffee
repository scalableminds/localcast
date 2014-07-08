_ = require("lodash")
Marionette = require("backbone.marionette")
Backbone = require("backbone")
PlaylistView = require("./playlist_view")
PlayerControlsView = require("./player_controls_view")
DragDropView = require("./drag_drop_view")
DeviceSelectionView = require("./device_selection_view")
app = require("../app")
PlaylistCollection = require("../models/playlist_collection")


module.exports = class MainLayouter extends Marionette.Layout

  template : _.template("""
    <section class="content-container"></section>
    <section class="modal-container"></section>
    <section class="navbar-bottom"></section>
  """)

  className : "container vbox"

  regions :
    "sectionContent" : ".content-container"
    "sectionControls" : ".navbar-bottom"
    "sectionModal" : ".modal-container"

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

    @deviceSelectionView = new DeviceSelectionView()

    @listenTo(@, "render", @showRegions)

    app.commands.execute("showCastDevices")


  showRegions : ->

    @sectionContent.show(@dragDropView)
    @sectionControls.show(@playerControlsView)
    @sectionModal.show(@deviceSelectionView)


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




