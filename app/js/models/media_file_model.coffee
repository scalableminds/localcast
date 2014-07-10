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
      isSelected : false
      isVideoCompatible : true
      isAudioCompatible : true

    validate : (file, options) ->

      @determineMIMEType(file) unless file.type

      unless file.type in @MEDIA_WHITELIST
        return Error("Unsupported Media File")


    initialize : (file) ->

      @determineMIMEType(file) unless file.type

      switch @get("type").split("/")[0]
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


    determineMIMEType : (file) ->

      # for some reason some media files don't have a MIME type

      fileExtension = file.path.match(/\.([A-Za-z]{3,4})$/)[1]

      MIMEType = switch fileExtension
        when "mkv"
          "video/mkv"

      file.type = MIMEType
      @set("type", MIMEType)







