_ = require("lodash")
Marionette = require("backbone.marionette")
Backbone = require("backbone")
app = require("../app")
require('backbone').$ = require("jquery")


class NotificationView extends Marionette.ItemView

  template : _.template("""
    <div>
      <button type="button" class="close pull-right">&times;</button>
      <% _.each(items, function(notification){ %>
        <div class="notification-message">
          <span class="fa fa-2x <%= getIcon(notification) %> pull-left"></span>
          <p class="<%= notification.type %>">
            <%= notification.message %>
          </p>
        </div>
        <% }) %>
    </div>
  """)

  className :  "notifications slide"

  events :
    "click .close" : "dismissAll"

  templateHelpers :

    getIcon : (notification) ->
      if notification.type == "normal"
        return "fa-info-circle"
      else
        return "fa-exclamation-triangle"


  initialize : ->

    @collection = new Backbone.Collection()

    @timer = ->
      setTimeout( =>
          @trigger("tick", @lastTick)
          @lastTick = Date.now()
          @timer()
        , 100
      )
    @timer()


  error : (message) ->

    @show(message, error)


  show : (message, type = "normal") ->

    if message
      notification =
        message : message
        type : type
      @collection.add(notification)

      @showNotification()


  showNotification : ->

    @render()
    @$el.addClass("in")

    # show notifications FIFO
    setTimeout( =>
      @removeNotification()
    , 3000
    )

  removeNotification : ->
    firstModel = @collection.first()
    @collection.remove(firstModel)
    @close()

  close : ->

    @$el.removeClass("in")

  dismissAll : ->

    @collection.reset()
    @render()
    @close()


module.exports = new NotificationView()
