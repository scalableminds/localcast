_ = require("lodash")
Marionette = require("backbone.marionette")
app = require("../app.js")
PlaylistItemView = require("./playlist_item_view")

module.exports = class PlaylistView extends Marionette.CompositeView

  template : _.template("""
     <table class="table">
      <thead>
        <tr>
          <th>Title</th>
          <th>Duration</th>
          <th>Video compatible</th>
          <th>Audio compatible</th>
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
    @listenTo(app.vent, "controls:progressEnd", @nextTrack)


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

