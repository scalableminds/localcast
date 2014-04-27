define [
  "underscore",
  "backbone.marionette"
], (_, Marionette) ->

  class PlaylistView extends Backbone.Marionette.ItemView

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

    className : ->

      if @model.get("isActive")
        return "active"
      else
        return ""


    initialize : ->

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


    afterRender : ->

      # update classname
      @$el.attr("class", _.result(@, "className"))






