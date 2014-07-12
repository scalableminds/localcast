http = require("http")
express = require("express")
ip = require("ip")
_ = require("lodash")
Backbone = require("backbone")
app = require("./app")
ffmpeg = require("fluent-ffmpeg")
Notification = require("./views/notification_view")


class Server

  PORT : 9090

  constructor : ->

    _.extend(@, Backbone.Events)
    @listenTo(app.vent, "playlist:playTrack", (file) ->
      @file = file
    )

    @path = null

    server = express()
    server.use((err, req, res, next) ->
      console.error(err)
      res.send(500)
    )
    server.get("/chromecast/:cachebuster", (req, res, next) =>

      if @file

        if @file.get("isVideoCompatible") and @file.get("isAudioCompatible")
          res.sendfile(@file.get("path"))
          app.isTranscoding = false
        else
          Notification.error("You are trying to play back an unsupported file. We will try to live-encode this for you. (EXPERIMENTAL) This is very computational expensive.")
          @transcode(res)
          app.isTranscoding = true
    )
    server.listen(@PORT)


  getServerUrl : ->

    "http://#{ip.address()}:#{@PORT}"


  transcode : (res) ->

    proc = ffmpeg(@file.get("path"))
      .toFormat("matroska")

    if @file.get("isVideoCompatible")
      proc.videoCodec("copy")
    else
      proc.videoCodec("libx264")
      proc.addOptions(["-profile:v high", "-level 5.0"])

    if @file.get("isAudioCompatible")
      proc.audioCodec("copy")
    else
      proc.audioCodec("aac")
      proc.audioQuality(100)

    proc.on('start', (commandLine) ->
      console.log('Spawned Ffmpeg with command: ' + commandLine);
    )
    .on('error', (err) ->
      console.log('an error happened: ' + err.message, err)
    )

    proc.pipe(res, end : true)


module.exports = new Server()
