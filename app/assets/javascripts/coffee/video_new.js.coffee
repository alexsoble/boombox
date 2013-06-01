$ ->

  # MORE LINES (AND OH YEAH, SAVING LINES TO THE DATABASE)

  n = 0
  $(".lang1-line").livequery ->
    $(this).keyup (e) ->
      e.preventDefault
      if e.which == 13 and ($('.lang2-line').val() isnt '')
        entry = this.value
        that_entry = $('.lang2-line').val()
        console.log "entry: #{entry}, that_entry: #{that_entry}"
        time = $("#timer").html()
        $('#lang1-lyrics').append("<p><small>(#{time})</small>  #{entry}</p>")
        $('#lang2-lyrics').append("<p><small>(#{time})</small>  #{that_entry}</p>")
        $('.lang1-line').val('')
        $('.lang2-line').val('')
        $.post('/new_line')

  $(".lang2-line").livequery ->
    $(this).keyup (e) ->
      if e.which == 13 and ($('.lang1-line').val() isnt '')
        entry = this.value
        that_entry = $('.lang1-line').val()
        console.log "entry: #{entry}, that_entry: #{that_entry}"
        time = $("#timer").html()
        $('#lang2-lyrics').append("<p><small>(#{time})</small>  #{entry}</p>")
        $('#lang1-lyrics').append("<p><small>(#{time})</small>  #{that_entry}</p>")
        $('.lang1-line').val('')
        $('.lang2-line').val('')
        $.post('/new_line')

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
    user_submit = $("#new-video-submit").val()
    youtube_id = "#{user_submit}".replace "http://www.youtube.com/watch?v=", ""

    if (window.keyup isnt 1) and (user_submit.match(/youtube/) isnt null)
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
            onStateChange: onPlayerStateChange)
        $('#outer-video-box').mouseenter(-> 
          state = player.getPlayerState()
          if state == 1
            player.pauseVideo()
          if state == 2
            player.playVideo()
          )

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

      counter = setInterval(countVideoPlayTime, 500)
      done = false

      onPlayerStateChange = (event) ->
        stopVideo -> player.stopVideo()
        if event.data is YT.PlayerState.PLAYING and not done
          setTimeout stopVideo, 6000
          done = true

      # ADDING THE VIDEO LANGUAGE SELECTORS

      $('#video-language-dropdown').html('<ul class="nav nav-pills"> <li class="dropdown"> <a href="#" data-toggle="dropdown" class="dropdown-toggle">Video language: <b class="caret"></b></a> <ul class="dropdown-menu" id="menu1">  <li><a class="language-video-option" id="English">English</a></li> <li><a class="language-video-option" id="Spanish">Spanish</a></li> <li><a class="language-video-option" id="Chinese">Chinese</a></li> <li><a class="language-video-option" id="French">French</a></li> <li><a class="language-video-option" id="Norwegian">Norwegian</a></li> <li><a class="language-video-option" id="Hindi">Hindi</a></li> <li><a class="language-video-option" id="Korean">Korean</a></li> </ul> </li> </ul>')
      
      $('#translation-language-dropdown').html('<ul class="nav nav-pills"> <li class="dropdown"> <a href="#" data-toggle="dropdown" class="dropdown-toggle">Translation language: <b class="caret"></b></a> <ul class="dropdown-menu" id="menu1">  <li><a class="language-translation-option" id="English">English</a></li> <li><a class="language-translation-option" id="Spanish">Spanish</a></li> <li><a class="language-translation-option" id="Chinese">Chinese</a></li> <li><a class="language-translation-option" id="French">French</a></li> <li><a class="language-translation-option" id="Norwegian">Norwegian</a></li> <li><a class="language-translation-option" id="Hindi">Hindi</a></li> <li><a class="language-translation-option" id="Korean">Korean</a></li></ul></li></ul> ')

      # ADDING THE INPUT LINES

      $('#lang1-input').html('<div class="control-group"><div class="controls"><input type="text" class="input-xlarge lang1-line" id="1" size="40"></div></div>')
      $('#lang2-input').html('<div class="controls"><input type="text" class="input-xlarge lang2-line" id="1" size="40"></div>')
      $('#video-language-dropdown').prepend('<div id="timer"></div>')

      $('.done-button').html('<div class="btn btn-primary" id="done-button">Done</div>')
      $('.save-button').html('<div class="btn btn-primary" id="save-button">Save</div>')

      # AJAX - CREATE NEW VIDEO OBJECT IN DB; GET TITLE FROM YOUTUBE

      getTitle = (data) ->
        title = data.entry.title.$t
        $.post('/new_video', { 'video' : { 'youtube_id' : "#{youtube_id}", 'title' : "#{title}" } } )
        $('.very-wide-box').slideUp(1000).delay(1500).slideDown(1000).delay(1500).fadeIn(6000)
        slowTitleReplace = -> 
          $('.very-wide-box').html("<h2>#{title}</h2>")
        window.setTimeout(slowTitleReplace, 2000)

      getTitleFromYouTube = (handleData) ->
        $.get('https://gdata.youtube.com/feeds/api/videos/' + youtube_id + '?v=2&alt=json', 
          (data) ->
            handleData(data) )

      getTitleFromYouTube(getTitle) ->

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
