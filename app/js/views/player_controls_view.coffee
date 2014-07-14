_ = require("lodash")
Marionette = require("backbone.marionette")
app = require("../app")
Utils = require("../utils")


module.exports = class PlayerControlsView extends Marionette.ItemView

  template : _.template("""
    <div class="button-controls">
      <button class="btn btn-default previous">
        <span class="fa fa-backward fa-lg"></span>
      </button>
      <button class="btn btn-default play">
        <span class="fa fa-play fa-2x"></span>
      </button>
      <button class="btn btn-default next">
        <span class="fa fa-forward fa-lg"></span>
      </button>
    </div>
    <div class="hbox progress-controls flex-center">
      <span class="current-time">00:00</span>
      <div class="progress">
        <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>
        <div class="progress-handle"></div>
      </div>
      <span class="total-time">00:00</span>
    </div>
    <div class="shuffle-cast">
      <!--<span class="fa fa-random fa-lg disabled"></span>-->
      <span class="icon-chromecast"></span>
    </div>
  """)

  className :  "hbox flex-center player-controls"

  ui :
    "playButton" : ".play"
    "progressHandle" : ".progress-handle"
    "progressBar" : ".progress-bar"
    "progressContainer" : ".progress"
    "totalTimeLabel" : ".total-time"
    "currentTimeLabel" : ".current-time"


  events :
    "click @ui.playButton" : "playPauseTrack"
    "click @ui.progressContainer" : "seek"
    "click .next" : "nextTrack"
    "click .previous" : "previousTrack"
    "click .icon-chromecast" : "showDevices"


  initialize : ->

    @listenTo(app.vent, "app:stateChanged", @playPauseTrack)
    @listenTo(app.vent, "chromecast:status", @startProgress)

    @timer = ->
      setTimeout( =>
          @trigger("tick", @lastTick)
          @lastTick = Date.now()
          @timer()
        , 100
      )
    @timer()


  playPauseTrack : (arg) ->

    triggeredByEvent = _.isNumber(arg) # called by "app:stateChange" event

    switch app.state
      when app.IDLE
        app.vent.trigger("controls:play")
      when app.PLAYING
        @ui.playButton.find("span").addClass("fa-pause")
        @ui.playButton.find("span").removeClass("fa-play")
        app.vent.trigger("controls:pause") unless triggeredByEvent
      when app.PAUSED
        @ui.playButton.find("span").removeClass("fa-pause")
        @ui.playButton.find("span").addClass("fa-play")
        app.vent.trigger("controls:continue") unless triggeredByEvent


  nextTrack : ->

    app.vent.trigger("controls:next")


  previousTrack : ->

    app.vent.trigger("controls:previous")


  startProgress : (status) ->

    if status.media # only status responses to LOAD command contain media info
      @duration = status.media.duration * 1000 # convert to ms

    @currentTime = status.currentTime * 1000
    @ui.totalTimeLabel.text(Utils.msToHumanString(@duration))
    @ui.currentTimeLabel.text(Utils.msToHumanString(@currentTime))

    @stopListening(@, "tick", @showProgress) # reset
    @listenTo(@, "tick", @showProgress)


  showProgress : (lastTick, forceRender) ->

    if (app.state == app.PLAYING or forceRender)
      @currentTime += Date.now() - lastTick #ms
      @ui.currentTimeLabel.text(Utils.msToHumanString(@currentTime))

      offsetX = 100 * @currentTime / @duration
      offsetX += "%"

      @ui.progressBar.width(offsetX)
      @ui.progressHandle.css("left", offsetX)

    if (@currentTime >= @duration and not app.isTranscoding) # transcoding has no duration
      app.vent.trigger("controls:progressEnd")
      @stopListening(@, "tick", @showProgress)


  seek : (evt) ->

    unless app.isTranscoding or app.state == app.IDLE

      offsetX = evt.offsetX / @ui.progressContainer.width()
      @currentTime = offsetX * @duration

      app.vent.trigger("controls:seek", @currentTime)

      @stopListening(@, "tick", @showProgress) # reset
      @listenToOnce(@, "tick", (lastTick) -> @showProgress(lastTick, true)) # force rendering once, in case playback is paused


  showDevices : ->

    app.commands.execute("showCastDevices")
