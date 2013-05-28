      tag = document.createElement('script')
      tag.src = "https://www.youtube.com/iframe_api"
      firstScriptTag = document.getElementsByTagName('script')[0]
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)
      
      onYouTubeIframeAPIReady = ->
        player = new YT.Player("new-video-box",
          height: '315'
          width: '420'
          videoId: "#{youtube_id}"
          events:
            onReady: onPlayerReady
            onStateChange: onPlayerStateChange)

      onPlayerReady = (event) =>
        event.target.playVideo()

      done = false
      onPlayerStateChange = (event) =>
        if event.data is YT.PlayerState.PLAYING and not done
          setTimeout stopVideo, 6000
          done = true

      stopVideo = ->
        player.stopVideo()

      countVideoPlayTime() = ->
        exact_time = player.getCurrentTime()
        time = Math.round(exact_time)

      counter = setInterval(countVideoPlayTime, 1000)