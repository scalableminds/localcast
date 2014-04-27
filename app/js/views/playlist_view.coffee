define [
  "backbone.marionette"
  "./playlist_item_view"
], (Marionette, PlaylistItemView) ->

  class PlaylistView extends Backbone.Marionette.CompositeView

    template : _.template("""
       <table class="table">
        <thead>
          <tr>
            <th>Title</th>
            <th>Duration</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
    """)

    itemView : PlaylistItemView
    itemViewContainer : "tbody"
    className : "playlist full-height"

