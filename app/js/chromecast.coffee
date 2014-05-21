nodecastor = require("nodecastor")
Backbone = require("backbone")
_ = require("lodash")
app = require("./app")
server = require("./server")

module.exports = class Chromecast

  DEFAULT_MEDIA_RECEIVER : "CC1AD845"
  MEDIA_NAMESPACE : "urn:x-cast:com.google.cast.media"

  constructor : ->

    _.extend(@, Backbone.Events)

    nodecastor
      .scan()
      .on("online", (device) =>
        @connect(device)
      )
      .on("offline", (device) ->
        console.log("Removed device", device)
      )
      .start()

    @listenTo(app.vent, "playlist:playTrack", @playMedia)
    @listenTo(app.vent, "controls:pause", @pause)
    @listenTo(app.vent, "controls:continue", @play)
    @listenTo(app.vent, "controls:seek", @seek)


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

          if app.isCasting
            app.join(@MEDIA_NAMESPACE, @requestSession)
          else
            app.run(@MEDIA_NAMESPACE, @requestSession)
            app.isCasting = true
      )
    )

  requestSession : (err, session) =>

      if(!err)
        @session = session


  playMedia : (file) ->

    mediaInfo =
      contentId : "#{server.getServerUrl()}#{file.get('path')}",
      streamType : file.get("streamType"),
      contentType : file.get("type")

    request =
      type : "LOAD",
      media : mediaInfo

    @sendCommand(request)


  seek : (time) ->

    request =
      type : "SEEK",
      currentTime : time / 1000 #in seconds

    @sendCommand(request)


  play : ->

    request =
      type : "PLAY",

    @sendCommand(request)


  pause : ->

    request =
      type : "PAUSE",

    @sendCommand(request)


  sendCommand : (request) ->

    if @session

      request = _.extend(request,
        mediaSessionId : @mediaSessionId
        requestId : 123,
      )
      console.log request
      @session.send(request, (err, message) =>
        if (err)
          console.error("Unable to cast:", err.message)
          @device.stop()

        if message
          if message.type == "MEDIA_STATUS"
            @mediaSessionId = message.status[0].mediaSessionId
            console.log @mediaSessionId

          console.log("RESPONSE ", message)
      )





