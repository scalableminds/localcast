Backbone = require("Backbone")

module.exports = class MediaFileModel extends Backbone.Model

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

      switch file.type.split("/")[0]
        when"image"
          @set("streamType", "NONE")
        when"video"
          @set("streamType", "BUFFERED")





