define [
  "backbone"
  "./playlist_model"
], (Backbone, PlaylistModel) ->

  class PlaylistCollection extends Backbone.Collection

    model : PlaylistModel

