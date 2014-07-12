Backbone = require("Backbone")
Compatibility = require("../compatibility")
Notification = require("../views/notification_view")


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

      type = @determineMIMEType(file) || file.type

      unless file.type in @MEDIA_WHITELIST
        Notification.error("#{file.name} is unsupported!")
        return Error("Unsupported Media File")


    initialize : (file) ->

      type = @determineMIMEType(file) || file.type

      switch type.split("/")[0]
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

      fileExtension = file.path.match(/\.([A-Za-z]{2,4})$/)[1]

      MIMEType = switch fileExtension
        when "mkv"
          "video/mkv"

      @set("type", MIMEType)
      file.type = MIMEType







