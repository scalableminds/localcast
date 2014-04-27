define [
  "backbone.marionette"
], (Marionette, PlaylistItemView) ->

  class PlayerControlsView extends Backbone.Marionette.ItemView

    template : _.template("""
      <div class="button-controls">
        <button class="btn btn-default previous">
          <span class=" fa fa-backward fa-lg"></span>
        </button>
        <button class="btn btn-default play">
          <span class=" fa fa-play fa-2x"></span>
        </button>
        <button class="btn btn-default next">
          <span class=" fa fa-forward fa-lg"></span>
        </button>
      </div>
      <div class="hbox progress-controls flex-center">
        <span class="current-time">00:00</span>
        <div class="progress">
          <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;"></div>
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


