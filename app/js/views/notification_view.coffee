_ = require("lodash")
Marionette = require("backbone.marionette")
Backbone = require("backbone")
app = require("../app")
require('backbone').$ = require("jquery")


class NotificationView extends Marionette.ItemView

  TIMEOUT : 5000 #ms

  template : _.template("""
    <div>
      <button type="button" class="close pull-right">&times;</button>
      <% _.each(items, function(notification){ %>
        <div class="notification-message <%= notification.type %>" data-id="<%= notification.id %>">
          <span class="fa fa-2x <%= getIcon(notification) %> pull-left"></span>
          <p>
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
    @id = 0


  error : (message) ->

    @show(message, "error")


  show : (message, type = "normal") ->

    if message
      notification =
        message : message
        type : type
        id : @id++
      @collection.add(notification)

      @showNotification()

    return


  showNotification : ->

    @render()
    @$el.addClass("in")

    setTimeout( =>
      @removeNotification()
    , @TIMEOUT
    )


  removeNotification : ->

    # show notifications FIFO
    firstModel = @collection.first()
    @collection.remove(firstModel)

    # only close if there are no more notifications
    if @collection.length > 0
      @$("[data-id='#{firstModel.get('id')}']").fadeOut()
    else
      @dismissAll()


  close : ->

    @$el.removeClass("in")


  dismissAll : ->

    @collection.reset()
    @render()
    @close()


module.exports = new NotificationView()
