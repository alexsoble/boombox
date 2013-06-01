$ ->

# MORE LINES
  n = 0

  $(".lang1-line").livequery ->
    $(this).keypress (e) ->
      if e.which == 13
        n += 1
        $('#lang1-box').append('<div id="timer"></div><div class="controls"><input type="text" class="input-xlarge lang1-line" id="' + n + '"></div>')
        $('#lang2-box').append('<div id="timer"></div><div class="controls"><input type="text" class="input-xlarge lang2-line" id="' + n + '"></div>')
        data = this.value
        console.log "Content: #{data}, n: #{n}"
        $.post('/new_line')

  $(".lang2-line").livequery ->
    $(this).keypress (e) ->
      if e.which == 13
        $('#lang2-box').append('<div id="timer"></div><div class="controls"><input type="text" class="input-xlarge lang2-line" id="1"></div>')
        $('#lang1-box').append('<div id="timer"></div><div class="controls"><input type="text" class="input-xlarge lang1-line" id="1"></div>')

  $("#timer").livequery -> 
  
  $("#video-title").livequery ->

# DONE BUTTON

  $("#done-button").livequery ->
    $(this).click -> 
      # video_lang = $("#video-lang-choice").click()
      # console.log video_lang
      # translation_lang = $("#translation-lang-choice").click()
      # console.log translation_lang
      
      # window.location.href = "http://localhost:3000/welcome/?video_lang=#{video_lang}&translation_lang=#{translation_lang}"

# WHEN A NEW VIDEO URL GETS PASTED IN

  $("#new-video-submit").keyup =>
    user_url = $("#new-video-submit").val()
    console.log "user_url = #{user_url}"
    youtube_id = "#{user_url}".replace "http://www.youtube.com/watch?v=", ""
    console.log "youtube_id = #{youtube_id}"

    if window.keyup isnt 1
      window.keyup = 1
      console.log "keyup = #{keyup}"

      player = null

      tag = document.createElement("script")
      tag.src = "https://www.youtube.com/iframe_api"
      firstScriptTag = document.getElementsByTagName("script")[0]
      firstScriptTag.parentNode.insertBefore tag, firstScriptTag

      window.onYouTubeIframeAPIReady = ->
        player = new YT.Player("new-video-box",
          height: "315"
          width: "420"
          videoId: youtube_id
          events:
            onReady: onPlayerReady
            onStateChange: onPlayerStateChange
            )
        this

      onPlayerReady = (event) ->
        event.target.playVideo()

      countVideoPlayTime = ->
        exact_time = player.getCurrentTime()
        time = Math.round(exact_time)
        minutes = Math.floor(time / 60)
        if minutes < 10
          minutes = '0' + minutes
        seconds = time - minutes * 60
        if seconds < 10
          seconds = '0' + seconds
        $("#timer").html(minutes + ":" + seconds)

      onPlayerStateChange = (event) ->
        if event.data is YT.PlayerState.PLAYING and not done
          setTimeout stopVideo, 6000
          done = true

      counter = setInterval(countVideoPlayTime, 100)
      done = false

      # ADDING THE VIDEO LANGUAGE SELECTORS

      $('#video-language-dropdown').html('<ul class="nav nav-pills"> <li class="dropdown"> <a href="#" data-toggle="dropdown" class="dropdown-toggle">Video language: <b class="caret"></b></a> <ul class="dropdown-menu" id="menu1">  <li><a class="language-video-option" id="English">English</a></li> <li><a class="language-video-option" id="Spanish">Spanish</a></li> <li><a class="language-video-option" id="Chinese">Chinese</a></li> <li><a class="language-video-option" id="French">French</a></li> <li><a class="language-video-option" id="Norwegian">Norwegian</a></li> <li><a class="language-video-option" id="Hindi">Hindi</a></li> <li><a class="language-video-option" id="Korean">Korean</a></li> </ul> </li> </ul>')
      
      $('#translation-language-dropdown').html('<ul class="nav nav-pills"> <li class="dropdown"> <a href="#" data-toggle="dropdown" class="dropdown-toggle">Translation language: <b class="caret"></b></a> <ul class="dropdown-menu" id="menu1">  <li><a class="language-translation-option" id="English">English</a></li> <li><a class="language-translation-option" id="Spanish">Spanish</a></li> <li><a class="language-translation-option" id="Chinese">Chinese</a></li> <li><a class="language-translation-option" id="French">French</a></li> <li><a class="language-translation-option" id="Norwegian">Norwegian</a></li> <li><a class="language-translation-option" id="Hindi">Hindi</a></li> <li><a class="language-translation-option" id="Korean">Korean</a></li></ul></li></ul> ')

      # ADDING THE INPUT LINES

      $('#lyrics-form-left').html('<div id="timer"></div><div class="controls"><input type="text" class="input-xlarge lang1-line" id="1" size="40"></div>')
      $('#lyrics-form-right').html('<div class="controls"><input type="text" class="input-xlarge lang2-line" id="1" size="40"></div>')

      $('.done-button').html('<div class="btn btn-primary" id="done-button">Done</div>')
      $('.save-button').html('<div class="btn btn-primary" id="save-button">Save</div>')

      # $('.very-wide-box').slideUp()

      # AJAX

      getTitle = (data) ->
        title = data.entry.title.$t
        console.log title

      getTitleFromYouTube = (handleData) ->
        $.get('https://gdata.youtube.com/feeds/api/videos/' + youtube_id + '?v=2&alt=json', 
          (data) ->
            handleData(data) 
        )

      getTitleFromYouTube(getTitle) ->

      $.post('/new_video', { 'video' : {
          'youtube_id' : "#{youtube_id}",
          'title' : "#{title}" } }
      )

# VIDEO LANGUAGE SELECTORS

  $(".language-video-option").livequery ->
    $(this).click ->
      $("#video-language-dropdown").html("<a class=\"btn btn-primary\" id=\"video-lang-choice\">#{this.id}</a>")

  $(".language-translation-option").livequery ->
    $(this).click ->
      $("#translation-language-dropdown").html("<a class=\"btn btn-primary\" id=\"translation-lang-choice\">#{this.id}</a>")

  $("#video-lang-choice").livequery ->
    $(this).click ->
      return $(this).currentTarget.val()
  $("#translation-lang-choice").livequery ->
    $(this).click ->
      return $(this).currentTarget.val()
