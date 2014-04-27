define [
  "backbone"
], (Backbone) ->

  class MediaFileModel extends Backbone.Model

    MEDIA_WHITELIST : [
      "image/jpeg",
      "image/png",
      "image/gif",
      "video/mp4"
    ]

    defaults :
      duration : 0
      isActive : false

    validate : (file, options) ->

      unless file.type in @MEDIA_WHITELIST
        return Error("Unsupported Media File")


    initialize : (file) ->

      console.log "sfdsf"


