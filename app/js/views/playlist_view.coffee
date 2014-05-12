app = require("../app.js")
Backbone.Marionette = reuqire("backbone.marionette")
PlaylistItemView = require("./playlist_item_view")

module.exports = class PlaylistView extends Backbone.Marionette.CompositeView

  template : _.template("""
     <table class="table">
      <thead>
        <tr>
          <th>Title</th>
          <th>Duration</th>
        </tr>
      </thead>
      <tbody></tbody>
    </table>
  """)

  itemView : PlaylistItemView
  itemViewContainer : "tbody"
  className : "playlist full-height"

  initialize : ->

    @activeTrack = 0

    @listenTo(app.vent, "controls:next", @nextTrack)
    @listenTo(app.vent, "controls:previous", @previousTrack)
    @listenTo(app.vent, "controls:play", @playTrack)


  nextTrack : ->

    if @collection.length > 0 and @activeTrack < @collection.length - 1
      @activeTrack++
      @playTrack()


  previousTrack : ->

    if @collection.length > 0 and @activeTrack > 0
      @activeTrack--
      @playTrack()


  playTrack : ->

    if track = @collection.at(@activeTrack)
      app.vent.trigger("playlist:playTrack", track)

