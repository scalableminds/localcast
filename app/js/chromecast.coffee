nodecastor = require("nodecastor")
app = require("./app")
Backbone = require("backbone")

module.exports = class Chromecast extends Backbone.Events

  DEFAULT_MEDIA_RECEIVER : "CC1AD845"
  MEDIA_NAMESPACE : "urn:x-cast:com.google.cast.media"

  constructor : ->

    nodecastor
      .scan()
      .on("online", (device) =>
        @connect(device)
      )
      .on("offline", (device) ->
        console.log("Removed device", device)
      )
      .start()

    @listenTo(app, "playlist:playTrack", @playMedia)
    @isAppRunning = false


  connect : (device) ->

    device.on("connect", =>

      @device = device

      device.status((err, s) ->
        if (!err)
          console.log("Chromecast status", s)
      )

      device.on("status", (status) ->
        console.log("Chromecast status updated", status)
      )

      device.on("error", (err) ->
        console.error("An error occurred with some Chromecast device", err)
      )

      device.application(@DEFAULT_MEDIA_RECEIVER, (err, app) =>
        if (!err)
          console.log("Default Media Receiver", app)

          if @isAppRunning
            app.join(@MEDIA_NAMESPACE, @requestSession)
          else
            app.run(@MEDIA_NAMESPACE, @requestSession)
            @isAppRunning = true
      )
    )

  requestSession : (err, session) ->

      if(!err)
        @session = session


  playMedia : (file) ->

    if @session

      mediaInfo =
        contentId : file.getServerUrl(),
        streamType : file.get("streamType"),
        contentType : file.get("type")

      loadRequest =
        requestId : 123,
        type : "LOAD",
        media : mediaInfo

      session.send(loadRequest, (err, message) =>
        if (err)
          console.error("Unable to cast:", err.message)
          @device.stop()
      )





