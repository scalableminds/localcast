app = require("../app.js")
Marionette = require("backbone.marionette")
PlaylistItemView = require("./playlist_item_view")
_ = require("lodash")

module.exports = class PlaylistView extends Marionette.CompositeView

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

  className : "playlist full-height"
  itemView : PlaylistItemView
  itemViewContainer : "tbody"
  itemViewOptions : ->
    parent : @


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


  playTrack : (model) ->

    if model
      track = @collection.get(model)
      @activeTrack = @collection.indexOf(model)
    else
      track = @collection.at(@activeTrack)

    app.vent.trigger("playlist:playTrack", track)

