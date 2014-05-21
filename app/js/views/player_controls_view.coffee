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
      <span class="total-time">05:00</span>
    </div>
    <div class="shuffle-cast">
      <span class="fa fa-random fa-lg disabled"></span>
      <span class="fa fa-rss fa-lg disabled"></span>
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


  initialize : ->

    @listenTo(app.vent, "playlist:playTrack", @startProgress)
    @listenTo(app.vent, "playlist:playTrack", @playPauseTrack)

    @timer = ->
      setTimeout( =>
          @trigger("tick")
          @timer()
        , 100
      )
    @timer()


  playPauseTrack : (arg) ->

    unless arg.get
      #call was trigger by click on button not by event
      app.isPlaying = !app.isPlaying

      if @currentTime == 0
        app.vent.trigger("controls:play", app.isPlaying)

    if app.isPlaying
      @ui.playButton.find("span").removeClass("fa-play")
      @ui.playButton.find("span").addClass("fa-pause")
      app.vent.trigger("controls:continue")
    else
      @ui.playButton.find("span").removeClass("fa-pause")
      @ui.playButton.find("span").addClass("fa-play")
      app.vent.trigger("controls:pause")


  nextTrack : ->

    app.vent.trigger("controls:next")


  previousTrack : ->

    app.vent.trigger("controls:previous")


  startProgress : (file) ->

    @duration = file.get("duration")
    @currentTime = 0
    @ui.totalTimeLabel.text(Utils.msToHumanString(@duration))
    @ui.currentTimeLabel.text(Utils.msToHumanString(@currentTime))

    @stopListening(@, "tick", @showProgress) # reset
    @listenTo(@, "tick", @showProgress)


  showProgress : ->

    if (app.isPlaying)
      @currentTime += 100 #ms
      @ui.currentTimeLabel.text(Utils.msToHumanString(@currentTime))

      offsetX = 100 * @currentTime / @duration
      offsetX += "%"

      @ui.progressBar.width(offsetX)
      @ui.progressHandle.css("left", offsetX)

    if (@currentTime >= @duration)
      app.vent.trigger("controls:progressEnd")
      @stopListening(@, "tick", @showProgress)


  seek : (evt) ->

    offsetX = evt.offsetX / @ui.progressContainer.width()
    @currentTime = offsetX * @duration

    app.vent.trigger("controls:seek", @currentTime)

    @stopListening(@, "tick", @showProgress) # reset
    @listenTo(@, "tick", @showProgress)

