ffprobe = require ("node-ffprobe")

module.exports =

  cache : {}

  probe : (file, cb) ->

    filePath = file.get("path")
    if value = @cache[filePath]
      cb(value)

    else
      ffprobe(filePath, (err, probeData) =>

        unless err

          result =
            isVideoCompatible : @isVideoCompatible(probeData)
            isAudioCompatible : @isAudioCompatible(probeData)
            duration : @duration(probeData)

          @cache[filePath] = result
          cb(result)
      )


  isVideoCompatible : (probeData) ->

    isCompatible = false
    probeData.streams.forEach((stream) ->

      if stream.codec_type == "video"

        if stream.codec_name == "h264" && (stream.profile == "High" || stream.profile == "Main") &&
          (stream.level == 31 || stream.level == 40 || stream.level == 41 || stream.level == 42 || stream.level == 5 || stream.level == 50 || stream.level == 51)
            isCompatible = true

        else if stream.codec_name == "vp8"
          isCompatible = true
    )

    return isCompatible


  isAudioCompatible : (probeData) ->

    isCompatible = false
    probeData.streams.forEach((stream) ->

      if stream.codec_type == "audio"
        if stream.codec_name == "aac" || stream.codec_name == "mp3" || stream.codec_name == "vorbis" || stream.codec_name == "opus"
          isCompatible = true
    )

    return isCompatible


  duration : (probeData) ->

    probeData.format.duration * 1000 # convert to ms
