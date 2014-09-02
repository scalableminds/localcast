_ = require("lodash")
Marionette = require("backbone.marionette")
Backbone = require("backbone")
$ = require("jquery")
app = require("../app")
Utils = require("../utils")

module.exports = class DeviceSelectionView extends Marionette.ItemView

  template : _.template("""
    <div class="header">
      <button type="button" class="close">&times;</button>
      <h4 class="modal-title">Select a casting device</h4>
    </div>
    <div class="body">
      <ul>
      <% _.each(items, function(device){ %>
        <li>
          <a data-id="<%= device.id %>" href="#">
            <span class="icon-chromecast"></span>
            <span class="device"><%= device.friendlyName %></span>
          </a>
        </li>
      <% }) %>
      <% if (items.length == 0){ %>
        <li>No casting device found.</li>
      <% } %>
      </ul>
    </div>
  """)
  className : "device-selection fade"

  events :
    "click .close" : "close"
    "click a" : "selectDevice"

  initialize : ->

    @collection = new Backbone.Collection()

    @listenTo(app.vent, "chromecast:device_found", @addDeviceToCollection)
    @listenTo(@collection, "add", @render)
    @listenTo(@collection, "render", @render)
    app.commands.setHandler("showCastDevices", @showDeviceSelection.bind(this)) #showing the dialog again will not refresh the device list


  scanForDevices : ->

    @collection.reset()
    app.commands.execute("scanForDevices")
    @render()


  addDeviceToCollection : (device) ->

    # prevent double entries
    unless @collection.findWhere(friendlyName: device.friendlyName)
      @collection.add(device)


  showDeviceSelection : ->

    @scanForDevices()
    @render()
    @show()


  selectDevice : (evt) ->

    deviceID = $(evt.currentTarget).data("id")
    deviceModel = @collection.findWhere(id : deviceID)
    app.commands.execute("useDevice", deviceModel.attributes)

    @close()


  show : ->

    @$el.show()
    _.defer( => @$el.addClass("in"))


  close : ->

    @$el.removeClass("in")
    setTimeout(
      =>
        @$el.hide()
      , 150 # .15s transition
    )


