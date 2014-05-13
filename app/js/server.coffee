http = require("http")
ecstatic = require("ecstatic")
ip = require("ip")

class Server

  PORT : 9090

  constructor : ->

    http.createServer(
      ecstatic(root: "/" )
    ).listen(@PORT)


  getServerUrl : ->

    "http://#{ip.address()}:#{@PORT}"


module.exports = new Server()
