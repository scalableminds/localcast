define [
  "backbone"
  "./media_file_model"
], (Backbone, MediaFileModel) ->

  class PlaylistCollection extends Backbone.Collection

    model : MediaFileModel

