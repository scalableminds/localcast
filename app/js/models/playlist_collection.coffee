Backbone = require("backbone")
MediaFileModel = require("./media_file_model")

module.exports = class PlaylistCollection extends Backbone.Collection

    model : MediaFileModel

