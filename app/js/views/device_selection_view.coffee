_ = require("lodash")
Marionette = require("backbone.marionette")
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
      <% _.each(obj, function(device){ %>
        <li>
          <a data-id="<%= device.id %>" href="#">
            <span class="icon-chromecast"></span>
            <span class="device"><%= device.friendlyName %></span>
          </a>
        </li>
      <% }) %>
      </ul>
    </div>
  """)
  className : "device-selection fade"

  events :
    "click .close" : "close"
    "click a" : "selectDevice"

  initialize : ->

    @listenTo(@, "show", @afterRender)


  serializeData : ->

    return @collection


  selectDevice : (evt) ->

    deviceID = $(evt.currentTarget).data("id")
    deviceModel = _.findWhere(@collection, id : deviceID)
    app.vent.trigger("device-selection:selected", deviceModel)

    @close()


  afterRender : ->

    @$el.addClass("in")


  close : ->

    @$el.removeClass("in")


