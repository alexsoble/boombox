$ ->

  $("#select-language-box").hide()

  # MORE LINES (AND OH YEAH, SAVING LINES TO THE DATABASE)

  n = 0
  $(".lang1-line").livequery ->
    $(this).keyup (e) ->
      e.preventDefault
      if e.which == 13 and ($('.lang2-line').val() isnt '')
        entry = this.value
        that_entry = $('.lang2-line').val()
        console.log "entry: #{entry}, that_entry: #{that_entry}"
        time = $("#timer").text()
        $('#lang1-lyrics').append("<p><small><small>(#{time})</small></small>  #{entry}</p>")
        $('#lang2-lyrics').append("<p><small><small>(#{time})</small></small>  #{that_entry}</p>")
        $('.lang1-line').val('')
        $('.lang2-line').val('')
        time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
        console.log time_in_seconds
        $.post('/new_line', { 'line' : { 'lang1' : "#{entry}", 'lang2' : "#{that_entry}", 'time' : "#{time_in_seconds}" } } )

  $(".lang2-line").livequery ->
    $(this).keyup (e) ->
      if e.which == 13 and ($('.lang1-line').val() isnt '')
        entry = this.value
        that_entry = $('.lang1-line').val()
        console.log "entry: #{entry}, that_entry: #{that_entry}"
        time = $("#timer").text()
        $('#lang2-lyrics').append("<p><small>(#{time})</small>  #{entry}</p>")
        $('#lang1-lyrics').append("<p><small>(#{time})</small>  #{that_entry}</p>")
        $('.lang1-line').val('')
        $('.lang2-line').val('')
        time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
        console.log time_in_seconds
        $.post('/new_line', { 'line' : { 'lang1' : "#{that_entry}", 'lang2' : "#{entry}", 'time' : "#{time_in_seconds}" } } )

# DONE BUTTON RESPONSE

  $("#done-button").livequery ->
    $(this).click -> 
      # video_lang = $("#video-lang-choice").click()
      # console.log video_lang
      # translation_lang = $("#translation-lang-choice").click()
      # console.log translation_lang
      
      # window.location.href = "http://localhost:3000/welcome/?video_lang=#{video_lang}&translation_lang=#{translation_lang}"

# WHEN A NEW VIDEO URL GETS PASTED IN

  # VALIDATING THE URL AGAINST YOUTUBE SYNTAX 

  $("#new-video-submit").keyup =>
    user_submit = $("#new-video-submit").val()
    youtube_id = "#{user_submit}".replace "http://www.youtube.com/watch?v=", ""
    window.youtube_id = "#{youtube_id}"
    if youtube_id.match(/&list/)
      youtube_id = youtube_id.slice(0,11)
      window.youtube_id = "#{youtube_id}"

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
        $(".timer-text").html(minutes + ":" + seconds)

      counter = setInterval(countVideoPlayTime, 500)
      done = false

      onPlayerStateChange = (event) ->
        stopVideo -> player.stopVideo()
        if event.data is YT.PlayerState.PLAYING and not done
          setTimeout stopVideo, 6000
          done = true

      # ADDING THE VIDEO LANGUAGE SELECTORS        

      $("#select-language-box").slideDown()

      slowSelectorAdd = -> 

        $('#video-language-dropdown').html('<h3>This video is in:</h3>
        <ul class="nav nav-pills" id="video-language-options">
          <li class="dropdown"> 
            <a href="#" data-toggle="dropdown" class="dropdown-toggle">Select language<b class="caret"></b></a> 
            <ul class="dropdown-menu" id="menu1">
              <li><a class="language-video-option" id="English">English</a></li> 
              <li><a class="language-video-option" id="Chinese">Chinese</a></li>
              <li><a class="language-video-option" id="Korean">Korean</a></li> 
              <li><a class="language-video-option" id="Japanese">Japanese</a></li> 
              <li><a class="language-video-option" id="Spanish">Spanish</a></li> 
              <li><a class="language-video-option" id="French">French</a></li> 
              <li><a class="language-video-option" id="German">German</a></li> 
              <li><a class="language-video-option" id="Italian">Italian</a></li> 
              <li><a class="language-video-option" id="Norwegian">Norwegian</a></li> 
              <li><a class="language-video-option" id="Hebrew">Hebrew</a></li> 
              <li><a class="language-video-option" id="Arabic">Arabic</a></li> 
              <li><a class="language-video-option" id="Persian">Persian</a></li> 
              <li><a class="language-video-option" id="Hindi">Hindi</a></li></ul></li></ul>')
        
        $('#translation-language-dropdown').html('<h3>I\'m translating it into:</h3>
          <ul class="nav nav-pills" id="translation-language-options">
            <li class="dropdown">
              <a href="#" data-toggle="dropdown" class="dropdown-toggle">Select language<b class="caret"></b></a> 
                <ul class="dropdown-menu" id="menu1">
                <li><a class="language-translation-option" id="English">English</a></li> 
                <li><a class="language-translation-option" id="Chinese">Chinese</a></li>
                <li><a class="language-translation-option" id="Korean">Korean</a></li> 
                <li><a class="language-translation-option" id="Japanese">Japanese</a></li> 
                <li><a class="language-translation-option" id="Spanish">Spanish</a></li> 
                <li><a class="language-translation-option" id="French">French</a></li> 
                <li><a class="language-translation-option" id="German">German</a></li> 
                <li><a class="language-translation-option" id="Italian">Italian</a></li> 
                <li><a class="language-translation-option" id="Norwegian">Norwegian</a></li> 
                <li><a class="language-translation-option" id="Hebrew">Hebrew</a></li> 
                <li><a class="language-translation-option" id="Arabic">Arabic</a></li> 
                <li><a class="language-translation-option" id="Persian">Persian</a></li> 
                <li><a class="language-translation-option" id="Hindi">Hindi</a></li></ul></li></ul>')
        
        $('#timer-box').html('<div id="timer"><h2 class="timer-text" id="big-timer"></h2></div>')

      window.setTimeout(slowSelectorAdd, 2000)

      # AJAX - OH YEAH
      # CREATE NEW VIDEO OBJECT IN DB
      # GET TITLE FROM YOUTUBE

      getTitle = (data) ->
        title = data.entry.title.$t
        $.post('/new_video', { 'video' : { 'youtube_id' : "#{youtube_id}", 'title' : "#{title}" } } )
        $('.very-wide-box').slideUp(1000).delay(1500).slideDown(1000).delay(1500).fadeIn(6000)
        slowTitleReplace = -> 
          $('#copy-and-paste-box').html("<h2>#{title}</h2>")
        window.setTimeout(slowTitleReplace, 2000)

      getTitleFromYouTube = (handleData) ->
        $.get('https://gdata.youtube.com/feeds/api/videos/' + youtube_id + '?v=2&alt=json', 
          (data) ->
            handleData(data) )

      getTitleFromYouTube(getTitle) ->

# VIDEO LANGUAGE SELECTORS + ADDING THE FIRST INPUT LINES

  $(".language-video-option").livequery ->
    $(this).click ->
      lang1 = this.id
      $("#video-language-options").html("<a class='btn btn-primary backtrack' id='video-lang-choice'>#{lang1}</a>")

  $('.backtrack#video-lang-choice').livequery ->
    $(this).click ->
      $('#video-language-dropdown').html('<h3>This video is in:</h3>
      <ul class="nav nav-pills" id="video-language-options">
        <li class="dropdown"> 
          <a href="#" data-toggle="dropdown" class="dropdown-toggle">Select language<b class="caret"></b></a> 
          <ul class="dropdown-menu" id="menu1">
            <li><a class="language-video-option" id="English">English</a></li> 
            <li><a class="language-video-option" id="Chinese">Chinese</a></li>
            <li><a class="language-video-option" id="Korean">Korean</a></li> 
            <li><a class="language-video-option" id="Japanese">Japanese</a></li> 
            <li><a class="language-video-option" id="Spanish">Spanish</a></li> 
            <li><a class="language-video-option" id="French">French</a></li> 
            <li><a class="language-video-option" id="German">German</a></li> 
            <li><a class="language-video-option" id="Italian">Italian</a></li> 
            <li><a class="language-video-option" id="Norwegian">Norwegian</a></li> 
            <li><a class="language-video-option" id="Hebrew">Hebrew</a></li> 
            <li><a class="language-video-option" id="Arabic">Arabic</a></li> 
            <li><a class="language-video-option" id="Persian">Persian</a></li> 
            <li><a class="language-video-option" id="Hindi">Hindi</a></li></ul></li></ul>')

  $(".language-translation-option").livequery ->
    $(this).click ->
      lang1 = $("#video-lang-choice").html()
      lang2 = this.id
      $("#translation-language-options").html("<a class='btn btn-primary' id='translation-lang-choice'>#{lang2}</a>")

      # TALK TO THE SERVER HERE

      $.post('/new_interp', { 'interpretation' : { 'youtube_id' : "#{window.youtube_id}" , 'lang1' : "#{lang1}", 'lang2' : "#{lang2}" } } )

      # INPUT LINES COME IN HERE

      $('#lang1-input').html("<i class='left'>#{lang1}&nbsp;</i><small class='left'>(<small class='timer-text'></small>)</small><div class='control-group'><div class='controls'><input type='text' class='input-xlarge lang1-line' id='1' size='40'></div></div>")
      $('#lang2-input').html("<i class='left'>#{lang2}&nbsp;</i><small class='left'>(<small class='timer-text'></small>)</small><div class='controls'><input type='text' class='input-xlarge lang2-line' id='1' size='40'></div>")

      # DONE AND SHOW BUTTONS ADDED HERE

      $('.done-button').html('<div class="btn btn-primary" id="done-button">Done</div>')
      $('.save-button').html('<div class="btn btn-primary" id="save-button">Save</div>')

      $("#select-language-box").slideUp('1000')
