nodecastor = require("nodecastor")
Backbone = require("backbone")
_ = require("lodash")
app = require("./app")
server = require("./server")
Notification = require("./views/notification_view")

module.exports = class Chromecast

  DEFAULT_MEDIA_RECEIVER : "CC1AD845"
  MEDIA_NAMESPACE : "urn:x-cast:com.google.cast.media"

  constructor : ->

    _.extend(@, Backbone.Events)

    @listenTo(app.vent, "playlist:playTrack", @playMedia)
    @listenTo(app.vent, "controls:pause", @pause)
    @listenTo(app.vent, "controls:continue", @play)
    @listenTo(app.vent, "controls:seek", @seek)
    app.commands.setHandler("useDevice", @connect.bind(@))
    app.commands.setHandler("scanForDevices", @scan)

    @requestId = 0


  scan : ->
    nodecastor
      .scan()
      .on("online", (device) =>
        device.on("error", (err) ->
          console.error(err)
          app.vent.trigger("chromecast:device_disconnected", device)
        )
        app.vent.trigger("chromecast:device_found", device)
      )
      .on("offline", (device) ->
        console.log("Removed device", device)
      )
      .on("error", (err) ->
        console.error(err)
      )
      .start()


  connect : (device) ->

    # trying to connected to same device?
    if device == @device
      return

    # in case we were previously casting, stop
    if app.isCasting
      app.isCasting = false
      @stop()

    @device = new nodecastor.CastDevice(device)

    @device.on("disconnect", ->
      console.log arguments
    )

    @device.on("connect", =>

      @device.status((err, s) ->
        if (!err)
          console.log("Chromecast status", s)
      )

      @device.on("status", (status) ->
        console.log("Chromecast status updated", status)
      )

      @device.application(@DEFAULT_MEDIA_RECEIVER, (err, receiver_app) =>
        if (!err)

          if app.isCasting
            receiver_app.join(@MEDIA_NAMESPACE, @requestSession)
          else
            receiver_app.run(@MEDIA_NAMESPACE, @requestSession)
      )

    )

  requestSession : (err, session) =>

    if(!err)
      @session = session
      app.isCasting = true


  disconnect : ->

    if @device
      @stop()
      @device.stop()
      #TODO Maybe launch the Home screen app


  playMedia : (file) ->

    if @device and @session and file

      app.changeState(app.PLAYING)
      mediaInfo =
        contentId : "#{server.getServerUrl()}/chromecast/#{Date.now()}",
        streamType : file.get("streamType"),
        contentType : file.get("type")

      request =
        type : "LOAD",
        media : mediaInfo

      #the LOAD command's response contains the mediaSessionId
      @mediaSessionId = null
      @sendCommand(request)


  seek : (time) ->

    request =
      type : "SEEK",
      currentTime : time / 1000 #in seconds

    @sendCommand(request)


  play : ->

    app.changeState(app.PLAYING)
    request =
      type : "PLAY",

    @sendCommand(request)


  pause : ->

    app.changeState(app.PAUSED)
    request =
      type : "PAUSE",

    @sendCommand(request)


  stop : ->

    app.changeState(app.IDLE)
    request =
      type : "STOP",

    @sendCommand(request)


  sendCommand : (request) ->

    if @session

      request = _.extend(request,
        mediaSessionId : @mediaSessionId
        requestId : @requestId++,
      )
      console.log "COMMAND ", request
      @session.send(request, @handleCastResponse.bind(this))


  handleCastResponse : (err, message) ->

    if (err)
      console.error("Unable to cast:", err.message)
      #Notification.error("Unable to cast:" + err.message)
      @device.stop()

    if message
      if message.type == "MEDIA_STATUS"
        status = message.status[0]
        @mediaSessionId = status.mediaSessionId
        Notification.show("Media Status: " + status.playerState)

        app.vent.trigger("chromecast:status", status)

    console.log("RESPONSE ", message)



