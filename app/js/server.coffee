http = require("http")
express = require("express")
ip = require("ip")
_ = require("lodash")
Backbone = require("backbone")
app = require("./app")


class Server

  PORT : 9090

  constructor : ->

    _.extend(@, Backbone.Events)
    @listenTo(app.vent, "playlist:playTrack", (file) ->
      @path = file.get("path")
    )

    @path = null

    server = express()
    server.get("/chromecast/:cachebuster", (req, res, next) =>
      if @path
        res.sendfile(@path)
      else
        res.send(404)
    )
    server.listen(@PORT)


  getServerUrl : ->

    "http://#{ip.address()}:#{@PORT}"


module.exports = new Server()
