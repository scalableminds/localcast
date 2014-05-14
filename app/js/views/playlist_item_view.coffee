_ = require("lodash")
app = require("../app")
Marionette = require("backbone.marionette")

module.exports = class PlaylistView extends Marionette.ItemView

  tagName: "<tr>"
  template : _.template("""
    <td>
      <%= name %>
      <% if(isActive) { %>
        <span class="fa fa-volume-up"></span>
      <% } %>
    </td>
    <td><%= duration %></td>
  """)

  events :
    "dblclick" : "playTrack"

  className : ->

    if @model.get("isActive")
      return "active"
    else
      return ""


  initialize : (options) ->

    {@parent} = options

    @listenTo(app.vent, "playlist:playTrack", @update)
    @listenTo(@, "render", @afterRender)


  update : (newTrack) ->

    # check if track was previously active and needs reset
    if @model.get("isActive")
      @model.set("isActive", @model == newTrack)
      @render()

    # check if track just became active
    else
      @model.set("isActive", @model == newTrack)
      if @model.get("isActive")
        @render()


  playTrack : ->

    @parent.playTrack(@model)


  afterRender : ->

    # update classname
    @$el.attr("class", _.result(@, "className"))




