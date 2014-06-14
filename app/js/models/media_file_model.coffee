Backbone = require("Backbone")
Compatibility = require("../compatibility")


module.exports = class MediaFileModel extends Backbone.Model

    MEDIA_WHITELIST : [
      "image/jpeg",
      "image/png",
      "image/gif",
      "image/webp",
      "image/bmp",
      "video/mp4",
      "video/avi",
      "video/mkv",
      "video/webm",
      "audio/ogg",
      "audio/mp3",
      "audio/acc",
      "audio/vorbis"
    ]

    defaults :
      duration : 15000 #ms
      isActive : false
      isVideoCompatible : true
      isAudioCompatible : true

    validate : (file, options) ->

      unless file.type in @MEDIA_WHITELIST
        return Error("Unsupported Media File")


    initialize : (file) ->

      switch file.type.split("/")[0]
        when "image"
          @set("streamType", "NONE")
          @set("duration", 15000)

        when "video"
          @set("streamType", "BUFFERED")
          @checkCompatibility()

        when "audio"
          @set("streamType", "BUFFERED")
          @checkCompatibility()


    checkCompatibility : ->

      Compatibility.probe(@, @set.bind(@))




