$ ->

  $(".language-video-option").livequery ->
    $(this).click ->
      $("#video-language-dropdown").html("<a class=\"btn btn-primary\" id=\"video-lang-choice\">#{this.id}</a>")

  $(".language-translation-option").livequery ->
    $(this).click ->
      $("#translation-language-dropdown").html("<a class=\"btn btn-primary\" id=\"translation-lang-choice\">#{this.id}</a>")

  $(".line").livequery ->
    $(this).keypress (e) ->
      if e.which == 13
        $('#lyrics-form').append('<div class=\"controls\"><input type=\"text\" class=\"input-xlarge line\" id=\"1\"></div>')

  $("#video-lang-choice").livequery ->
    $(this).click ->
      return $(this).currentTarget.val()
  $("#translation-lang-choice").livequery ->
    $(this).click ->
      return $(this).currentTarget.val()

  $("#done-button").livequery ->
    $(this).click -> 
      video_lang = $("#video-lang-choice").click()
      console.log video_lang
      translation_lang = $("#translation-lang-choice").click()
      console.log translation_lang
      window.location.href = "http://localhost:3000/welcome/?video_lang=#{video_lang}&translation_lang=#{translation_lang}"

  $("#new-video-submit").keyup =>
    user_url = $("#new-video-submit").val()
    console.log "user_url = #{user_url}"
    youtube_id = "#{user_url}".replace "http://www.youtube.com/watch?v=", ""
    console.log "youtube_id = #{youtube_id}"
    if window.keyup isnt 1

      window.keyup = 1
      console.log "keyup = #{keyup}"
      
      onYouTubeIframeAPIReady = ->
        player = new YT.Player("new-video-box",
          height: '315'
          width: '420'
          videoId: "#{youtube_id}"
          events:
            onReady: onPlayerReady
            onStateChange: onPlayerStateChange)

      onPlayerReady = (event) ->
        event.target.playVideo()

      done = false
      onPlayerStateChange = (event) ->
        if event.data is YT.PlayerState.PLAYING and not done
          setTimeout stopVideo, 6000
          done = true

      stopVideo = ->
        player.stopVideo()

      tag = document.createElement('script')
      tag.src = "https://www.youtube.com/iframe_api"
      firstScriptTag = document.getElementsByTagName('script')[0]
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

      $('#video-language-dropdown').html('<ul class="nav nav-pills"> <li class="dropdown"> <a href="#" data-toggle="dropdown" class="dropdown-toggle">Video language: <b class="caret"></b></a> <ul class="dropdown-menu" id="menu1">  <li><a class="language-video-option" id="English">English</a></li> <li><a class="language-video-option" id="Spanish">Spanish</a></li> <li><a class="language-video-option" id="Chinese">Chinese</a></li> <li><a class="language-video-option" id="French">French</a></li> <li><a class="language-video-option" id="Norwegian">Norwegian</a></li> <li><a class="language-video-option" id="Hindi">Hindi</a></li> <li><a class="language-video-option" id="Korean">Korean</a></li> </ul> </li> </ul>')
      
      $('#translation-language-dropdown').html('<ul class="nav nav-pills"> <li class="dropdown"> <a href="#" data-toggle="dropdown" class="dropdown-toggle">Translation language: <b class="caret"></b></a> <ul class="dropdown-menu" id="menu1">  <li><a class="language-translation-option" id="English">English</a></li> <li><a class="language-translation-option" id="Spanish">Spanish</a></li> <li><a class="language-translation-option" id="Chinese">Chinese</a></li> <li><a class="language-translation-option" id="French">French</a></li> <li><a class="language-translation-option" id="Norwegian">Norwegian</a></li> <li><a class="language-translation-option" id="Hindi">Hindi</a></li> <li><a class="language-translation-option" id="Korean">Korean</a></li>  </ul> </li> </ul> ')

      $('#lyrics-form').append('<div class=\"controls\"><input type=\"text\" class=\"input-xlarge line\" id=\"1\"></div>')

      $('.done-button-box').append("<div class=\"btn btn-primary\" id=\"done-button\">Done</div>")

      $('.very-wide-box').slideUp() 'fast'