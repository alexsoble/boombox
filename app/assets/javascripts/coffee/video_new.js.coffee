$ ->

  $("#select-language-box").hide()

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

      # CREATE NEW VIDEO OBJECT IN DB
      # GET TITLE FROM YOUTUBE

      getTitle = (data) ->
        window.title = data.entry.title.$t
        $.post('/new_video', { 'video' : { 'youtube_id' : "#{youtube_id}", 'title' : "#{window.title}" } }, (data) ->
          console.log data, "json")
        $('.very-wide-box').html("<h2>#{window.title}</h2>")
        $(".very-wide-box").hide()

      getTitleFromYouTube = (handleData) ->
        $.get('https://gdata.youtube.com/feeds/api/videos/' + youtube_id + '?v=2&alt=json', 
          (data) ->
            handleData(data) )

      getTitleFromYouTube(getTitle)

      # ADDING THE VIDEO LANGUAGE SELECTORS        

      $("#select-language-box").slideDown('slow')

      $('#video-language-dropdown').html("
      <br><br>
      <h3>Nice choice.</h3>
      <img src=http://img.youtube.com/vi/#{window.youtube_id}/2.jpg>
      <br><br>
      <h4>This video is in:</h4>
      <ul class='nav nav-pills' id='video-language-options'>
        <li class='dropdown center-pill'> 
          <a data-toggle='dropdown' class='dropdown-toggle center-pill'>Select language<b class='caret'></b></a> 
          <ul class='dropdown-menu'>
            <li><a class='language-video-option' id='English'>English</a></li> 
            <li><a class='language-video-option' id='Chinese'>Chinese</a></li>
            <li><a class='language-video-option' id='Korean'>Korean</a></li> 
            <li><a class='language-video-option' id='Japanese'>Japanese</a></li> 
            <li><a class='language-video-option' id='Spanish'>Spanish</a></li> 
            <li><a class='language-video-option' id='French'>French</a></li> 
            <li><a class='language-video-option' id='German'>German</a></li> 
            <li><a class='language-video-option' id='Italian'>Italian</a></li> 
            <li><a class='language-video-option' id='Norwegian'>Norwegian</a></li> 
            <li><a class='language-video-option' id='Hebrew'>Hebrew</a></li> 
            <li><a class='language-video-option' id='Arabic'>Arabic</a></li> 
            <li><a class='language-video-option' id='Persian'>Persian</a></li> 
            <li><a class='language-video-option' id='Hindi'>Hindi</a></li></ul></li></ul>")
      
      $('#translation-language-dropdown').html('<p>I\'m translating it into:</p>
        <ul class="nav nav-pills" id="translation-language-options">
          <li class="dropdown center-pill">
            <a href="#" data-toggle="dropdown" class="dropdown-toggle center-pill">Select language<b class="caret"></b></a> 
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

  # VIDEO LANGUAGE SELECTORS BEHAVIOR

  $(".language-video-option").livequery ->
    $(this).click ->
      lang1 = this.id
      $("#video-language-options").html("<a class='btn btn-info backtrack center-pill' id='video-lang-choice'>#{lang1}</a>")

  $('.backtrack#video-lang-choice').livequery ->
    $(this).click ->
      $('#video-language-dropdown').html('<p>This video is in:</p>
      <ul class="nav nav-pills" id="video-language-options">
        <li class="dropdown"> 
          <a href="#" data-toggle="dropdown" class="dropdown-toggle center-pill">Select language<b class="caret"></b></a> 
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
      window.lang1 = $("#video-lang-choice").html()
      window.lang2 = this.id
      $("#translation-language-options").html("<a class='btn btn-primary' id='translation-lang-choice'>#{lang2}</a>")

      # TALK TO THE SERVER HERE

      $.post('/new_interp', { 'interpretation' : { 'youtube_id' : "#{window.youtube_id}" , 'lang1' : "#{lang1}", 'lang2' : "#{lang2}" } }, (data) ->
          window.interp_id = data.data.id
          console.log window.interp_id)

      $("#select-language-box").slideDown()

      slowSplashPageContent = ->
        $("#select-language-box").html('<br><br><h1 style="text-align: center;">Thanks!</h1><br><br>
          <h2><i>A few things to know:</i></h2>
          <table style="border-collapse: separate; border-spacing: 20px 20px;" border="0">
            <tr><ol>
              <td><li>Hit the pin when you hear the words start.</li></td>
              <td class="style52"><a class="btn btn-info style52"><i class="icon-pushpin icon-2x"></i></a></td>
            </tr>
            <tr>
              <td><li>When you hit the pin, the video will start looping.  The default loop is 4 seconds.  </li></td>
              <td class="style52" style="text-align: center;"><h3 class="white">4</h3></td>
            </tr>
            <tr>
              <td><li>Use this button to adjust the loop.</li></td>
              <td class="style52"><a class="btn btn-info style52"><i class="icon-refresh icon-2x"></i></a></td>
            </tr>
            <tr>
              <td><li>Use the forward button to skip to the next loop.</li></td>
              <td class="style52"><a class="btn btn-info style52"><i class="icon-forward icon-2x"></i></a></td>
            </ol><tr>
          </table>
          <br>
          <a class="btn btn-info" id="lets-get-going">Makes sense. Let\'s get going!</a>')

      slowSplashPageContent()

  # SPLASH PAGE HERE

  $("#lets-get-going").livequery ->
    $(this).click ->
      $("#select-language-box").hide()

    # YOUTUBE PLAYER COMES IN HERE

      player = null
      window.rollover_pause = false

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

        $("#timer-toggle").livequery ->
          $(this).click ->
            $("#timer-box").toggle()

        $("#rollover-toggle").livequery ->
          $(this).click ->
            if window.rollover_pause == false
              window.rollover_pause = true

        # MOUSE ROLLOVER PAUSE 

        $('#outer-video-box').mouseenter(-> 
          if window.rollover_pause == true
            state = player.getPlayerState()
            if state == 1
              player.pauseVideo()
            if state == 2
              player.playVideo() )

      onPlayerReady = (event) ->
        event.target.playVideo()

      window.section = 0 
      window.time = 0
      window.loop = false

      countVideoPlayTime = ->
        exact_time = player.getCurrentTime()
        window.time = Math.round(exact_time)
        minutes = Math.floor(window.time / 60)
        if minutes < 10
          minutes = '0' + minutes
        seconds = window.time - minutes * 60
        if seconds < 10
          seconds = '0' + seconds
        $(".timer-text").html(minutes + ":" + seconds)

        current_loop_time = window.loop * window.section
        loop_minutes = Math.floor(current_loop_time / 60)
        if loop_minutes < 10
          loop_minutes = '0' + loop_minutes
        loop_seconds = current_loop_time - loop_minutes * 60
        if loop_seconds < 10
          loop_seconds = '0' + loop_seconds
        if window.loop != false
          $(".current-loop-time").html(loop_minutes + ":" + loop_seconds)
        else
          $(".current-loop-time").html(minutes + ":" + seconds)

        # LOOPING HAPPENS HERE
        if window.loop != false
          if exact_time > (window.loop) * (window.section + 1) - .25
            player.seekTo(window.loop * window.section, true)

      counter = setInterval(countVideoPlayTime, 500)
      done = false

      onPlayerStateChange = (event) ->
        stopVideo -> player.stopVideo()
        if event.data is YT.PlayerState.PLAYING and not done
          setTimeout stopVideo, 6000
          done = true

      # PLAYER SETTINGS

      $("#controls").html('
        <div class="btn-group">
          <a class="btn btn-info dropdown-toggle" data-toggle="dropdown" id="settings"><i class="icon-cog icon-2x"></i></a></span>
            <ul class="dropdown-menu">
              <li><a id="timer-toggle">Turn big timer on/off</a></li>
              <li><a id="rollover-toggle">Pause video on mouse rollover</a></li></ul>
          <a class="btn btn-info" id="pin"><i class="icon-pushpin icon-2x"></i></a>
        </div>
        <div class="btn-group">
          <a class="btn btn-info dropdown-toggle" data-toggle="dropdown" id="loop-length"><i class="icon-refresh icon-2x"></i></a></span>
          <ul class="dropdown-menu">
            <li><a id="no-loop">No loop</a></li>
            <li><a id="loop-2">2 seconds</a></li>
            <li><a id="loop-4">4 seconds</a></li>
            <li><a id="loop-8">8 seconds</a></li></ul>
          <a class="btn btn-info" id="backward"><i class="icon-step-backward icon-2x"></i></a>
          <a class="btn btn-info" id="forward"><i class="icon-step-forward icon-2x"></i></a>
        </div>')
      $("#loop-length").hide()
      $("#backward").hide()
      $("#forward").hide()

      delayedShow = -> 
        
        $(".very-wide-box").slideDown('3000')

        # DONE, SHOW BUTTONS, TIMER BOX

        # $('.done-button').html('<div class="btn btn-info" id="done-button">Done</div>')
        # $('.save-button').html('<div class="btn btn-info" id="save-button">Save</div>')
        $('#timer-box').html('<div id="timer"><h2 class="timer-text" id="big-timer"></h2></div>')
        $('#timer-box').hide()

      window.setTimeout(delayedShow, 3000)

      $("#no-loop").livequery ->
        $(this).click ->
          window.loop = false
          $("#no-loop").html('<strong>No loop</strong>')
          $("#loop-2").html('2 seconds')
          $("#loop-4").html('4 seconds')
          $("#loop-8").html('8 seconds')
          $("#forward").hide()
          $("#backward").hide()

      $("#loop-2").livequery ->
        $(this).click ->
          window.loop = 2
          window.section = window.time / 2
          $("#no-loop").html('No loop')
          $("#loop-2").html('<strong>2 seconds</strong>')
          $("#loop-4").html('4 seconds')
          $("#loop-8").html('8 seconds')
          $("#forward").show()
          $("#backward").show()

      $("#loop-4").livequery ->
        $(this).click ->
          window.loop = 4
          window.section = window.time / 4
          $("#no-loop").html('No loop')
          $("#loop-2").html('2 seconds')
          $("#loop-4").html('<strong>4 seconds</strong>')
          $("#loop-8").html('8 seconds')
          $("#forward").show()
          $("#backward").show()

      $("#loop-8").livequery ->
        $(this).click ->
          window.loop = 8
          window.section = window.time / 8
          $("#no-loop").html('No loop')
          $("#loop-2").html('2 seconds')
          $("#loop-4").html('4 seconds')
          $("#loop-8").html('<strong>8 seconds</strong>')
          $("#forward").show()
          $("#backward").show()

      $("#forward").livequery ->
        $(this).click -> 
          window.section += 1
          player.seekTo(window.loop * window.section, true)
          $("#looping-box").html(window.loop * window.section)

      $("#backward").livequery ->
        $(this).click -> 
          window.section -= 1
          player.seekTo(window.loop * window.section, true)
          $("#looping-box").html(window.loop * window.section)

      $("#pin").livequery ->
        $(this).click -> 
          $("#loop-length").show()
          $("#backward").show()
          $("#forward").show()
          $("#pin").attr('class', 'btn btn-warning')
          window.section = window.time / 4
          window.loop = 4
          $('#timer-box').show()

          # INPUT LINES COME IN HERE

          $('#lang1-input').html("<i class='left'>#{window.lang1}&nbsp;</i><small class='left'>(<small class='current-loop-time' id='current-loop-time'></small>)</small><div class='control-group'><div class='controls'><input type='text' class='input-xlarge lang1-line' id='1' size='40'></div></div>")
          $('#lang2-input').html("<i class='left'>#{window.lang2}&nbsp;</i><small class='left'>(<small class='current-loop-time'></small>)</small><div class='controls'><input type='text' class='input-xlarge lang2-line' id='1' size='40'></div>")


  # MORE LINES (AND OH YEAH, SAVING LINES TO THE DATABASE)

  $(".lang1-line").livequery ->
    $(this).keyup (e) ->
      e.preventDefault
      if e.which == 13 and ($('.lang2-line').val() isnt '')
        entry = this.value
        that_entry = $('.lang2-line').val()
        console.log "entry: #{entry}, that_entry: #{that_entry}"
        time = $("#current-loop-time").text()
        $('#lang1-lyrics').append("<p><small><small>(#{time})</small></small>  #{entry}</p>")
        $('#lang2-lyrics').append("<p><small><small>(#{time})</small></small>  #{that_entry}</p>")
        $('.lang1-line').val('')
        $('.lang2-line').val('')
        time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
        console.log time_in_seconds
        $.post('/new_line', { 'line' : { 'lang1' : "#{entry}", 'lang2' : "#{that_entry}", 'time' : "#{time_in_seconds}", 'interpretation_id' : "#{window.interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
          console.log data.data )
        window.section += 1

  $(".lang2-line").livequery ->
    $(this).keyup (e) ->
      if e.which == 13 and ($('.lang1-line').val() isnt '')
        entry = this.value
        that_entry = $('.lang1-line').val()
        console.log "entry: #{entry}, that_entry: #{that_entry}"
        time = $("#current-loop-time").text()
        $('#lang2-lyrics').append("<p><small><small>(#{time})</small></small>  #{entry}</p>")
        $('#lang1-lyrics').append("<p><small><small>(#{time})</small></small>  #{that_entry}</p>")
        $('.lang1-line').val('')
        $('.lang2-line').val('')
        time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
        console.log time_in_seconds
        $.post('/new_line', { 'line' : { 'lang1' : "#{that_entry}", 'lang2' : "#{entry}", 'time' : "#{time_in_seconds}", 'interpretation_id' : "#{window.interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
          console.log data.data )
        window.section += 1

# DONE BUTTON RESPONSE

  $("#done-button").livequery ->
    $(this).click -> 
      # video_lang = $("#video-lang-choice").click()
      # console.log video_lang
      # translation_lang = $("#translation-lang-choice").click()
      # console.log translation_lang
      
      # window.location.href = "http://localhost:3000/welcome/?video_lang=#{video_lang}&translation_lang=#{translation_lang}"