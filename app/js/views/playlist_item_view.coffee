define [
  "backbone.marionette"
], (Marionette) ->

  class PlaylistView extends Backbone.Marionette.ItemView

    tagName: "<tr>"
    template : _.template("""
      <td><%= name %></td>
      <td><%= duration %></td>
    """)
