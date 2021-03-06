_ = require("lodash")
Marionette = require("backbone.marionette")
app = require("../app")
Utils = require("../utils")
$ = require("jquery")

module.exports = class PlaylistView extends Marionette.ItemView

  tagName: "<tr>"
  template : _.template("""
    <td>
      <%= name %>
      <% if(isActive) { %>
        <span class="fa fa-volume-up"></span>
      <% } %>
    </td>
    <td><%= Utils.msToHumanString(duration) %></td>
    <td><i class="fa <% if (!isVideoCompatible || !isAudioCompatible){ %> fa-exclamation-circle <% } %>" title="This file is incompatible with Chromecast. This file needs to be live-encoded. (EXPERIMENTAL)"></td>
  """)

  templateHelpers :
    Utils : Utils

  events :
    "dblclick" : "playTrack"
    "click" : "selectTrack"
    "click" : "clickOrDBClick"

  className : ->

    klass = ""
    klass += "active " if @model.get("isActive")
    klass += "selected" if @model.get("isSelected")
    return klass


  initialize : (options) ->

    {@parent} = options

    @listenTo(app.vent, "playlist:playTrack", @update)
    @listenTo(@, "render", @afterRender)
    @listenTo(@model, "change", @render)

    @alreadyClicked = false


  update : (newTrack) ->

    # check if track was previously active and needs reset
    if @model.get("isActive")
      @model.set("isActive", @model == newTrack)
      @render()

    # check if track just became active
    else
      @model.set("isActive", @model == newTrack)
      if @model.get("isActive")
        @render()


  playTrack : ->

    @selectTrack()
    @parent.playTrack(@model)


  afterRender : ->

    # update classname
    @$el.attr("class", _.result(@, "className"))


  selectTrack : ->

    oldModel = @parent.collection.at(@parent.activeTrack)
    oldModel.set("isSelected", false)

    @parent.activeTrack = @parent.collection.indexOf(@model)
    @model.set("isSelected", true)

    @render()


  clickOrDBClick : ->

    if @alreadyClicked
      # dbclick
      @playTrack()
      @alreadyClicked = false
      clearTimeout(@timeout)
    else
      @timeout = setTimeout( =>
        @selectTrack()
        @alreadyClicked = false
      , 200)
      @alreadyClicked = true







