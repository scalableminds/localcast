http = require("http")
express = require("express")
ip = require("ip")
_ = require("lodash")
Backbone = require("backbone")
portscanner = require("portscanner")
app = require("./app")
ffmpeg = require("fluent-ffmpeg")
Notification = require("./views/notification_view")


class Server

  port : 9090

  constructor : ->

    _.extend(@, Backbone.Events)
    @listenTo(app.vent, "playlist:playTrack", (file) ->
      @file = file
    )

    @path = null

    portscanner.findAPortNotInUse(@port, @port + 1000, '127.0.0.1', (err, port) =>

      @port = port

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
            if app.hasFFmpegSupport
              Notification.error("You are trying to play back an unsupported file. We will try to live-encode this for you. (EXPERIMENTAL) This is very computational expensive.")
              @transcode(res)
              app.isTranscoding = true
            else
              Notification.error("Your file format may be unsupported by the Chromecast. Check our website for workarounds. We will try to play it anyway.")
              app.isTranscoding = false
              res.sendfile(@file.get("path"))
      )
      server.listen(@port)

    )

  getServerUrl : ->

    console.log "http://#{ip.address()}:#{@port}"
    return "http://#{ip.address()}:#{@port}"


  transcode : (res) ->

    proc = new ffmpeg(@file.get("path"))
    proc.toFormat("matroska")

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
