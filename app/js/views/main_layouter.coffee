_ = require("lodash")
app = require("../app")
Backbone = require("backbone")
Marionette = require("backbone.marionette")
PlaylistView = require("./playlist_view")
DragDropView = require("./drag_drop_view")
Notifications = require("./notification_view")
PlayerControlsView = require("./player_controls_view")
DeviceSelectionView = require("./device_selection_view")
PlaylistCollection = require("../models/playlist_collection")


module.exports = class MainLayouter extends Marionette.Layout

  template : _.template("""
    <section class="notification-container"></section>
    <section class="content-container"></section>
    <section class="modal-container"></section>
    <section class="navbar-bottom"></section>
  """)

  className : "container vbox"

  regions :
    "sectionContent" : ".content-container"
    "sectionControls" : ".navbar-bottom"
    "sectionModal" : ".modal-container"
    "sectionNotifications" : ".notification-container"

  events :
    "drop" : "fileDrop"


  initialize : ->

    @dragDropView = new DragDropView()
    @playerControlsView = new PlayerControlsView()
    @deviceSelectionView = new DeviceSelectionView()

    @playlistCollection = new PlaylistCollection()
    @playlistView = new PlaylistView(collection : @playlistCollection)

    @listenTo(@, "render", @showRegions)

    app.commands.execute("showCastDevices")


  showRegions : ->

    @sectionContent.show(@dragDropView)
    @sectionControls.show(@playerControlsView)
    @sectionModal.show(@deviceSelectionView)
    @sectionNotifications.show(Notifications)


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




