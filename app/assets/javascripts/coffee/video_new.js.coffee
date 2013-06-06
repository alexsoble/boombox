$ ->

  if window.location.search.match(/request=y/) then window.request = true else window.request = false
  $("#select-language-box").hide()
  $("#title-box").hide()
  $("#controls").hide() 

  # YOUTUBE WINDOW STICKY ON SCROLL

  $window = $(window)
  video_box = $('#outer-video-box')
  video_top = video_box.offset().top
  lyrics_container = $('.lyrics-container')
  $window.scroll ->
    video_box.toggleClass('sticky', $window.scrollTop() > video_top)
    lyrics_container.toggleClass('sticky', $window.scrollTop() > video_top)

  # STEP TWO OF THE PROCESS (ONCE YOUTUBE ID, TITLE & LANG1 ARE IN)

  step2 = -> 

    window.title = $('#title-box').text()
    $.post('/new_video', { 'video' : { 'youtube_id' : "#{window.youtube_id}", 'title' : "#{window.title}", 'lang1' : "#{window.lang1}" } }, (data) ->
      console.log data, "json"
      window.video_id = data.video.id)

    $("#select-language-box").slideDown('slow')

    if window.request == false
      $('#translation-language-dropdown').html("<br><br><p>I\'m translating it into:</p>
        <ul class='nav nav-pills' id='translation-language-options'>
          <li class='dropdown'>
            <a class='btn btn-info dropdown-toggle center-pill' data-toggle='dropdown'>Select language<b class='caret'></b></a> 
              <ul class='dropdown-menu'>
              <li><a class='new-interp-language' id='English'>English</a></li> 
              <li><a class='new-interp-language' id='Chinese'>Chinese</a></li>
              <li><a class='new-interp-language' id='Korean'>Korean</a></li> 
              <li><a class='new-interp-language' id='Japanese'>Japanese</a></li> 
              <li><a class='new-interp-language' id='Spanish'>Spanish</a></li> 
              <li><a class='new-interp-language' id='French'>French</a></li> 
              <li><a class='new-interp-language' id='German'>German</a></li> 
              <li><a class='new-interp-language' id='Italian'>Italian</a></li> 
              <li><a class='new-interp-language' id='Norwegian'>Norwegian</a></li> 
              <li><a class='new-interp-language' id='Hebrew'>Hebrew</a></li> 
              <li><a class='new-interp-language' id='Arabic'>Arabic</a></li> 
              <li><a class='new-interp-language' id='Persian'>Persian</a></li> 
              <li><a class='new-interp-language' id='Hindi'>Hindi</a></li></ul></li></ul>")

    if window.request == true
      $('#translation-language-dropdown').html("<br><br><p>I\'d like a translation of this video into:</p>
        <ul class='nav nav-pills' id='request-language-options'>
          <li class='dropdown'>
            <a class='btn btn-info dropdown-toggle center-pill' data-toggle='dropdown'>Select language<b class='caret'></b></a> 
              <ul class='dropdown-menu'>
              <li><a class='request-language' id='English'>English</a></li> 
              <li><a class='request-language' id='Chinese'>Chinese</a></li>
              <li><a class='request-language' id='Korean'>Korean</a></li> 
              <li><a class='request-language' id='Japanese'>Japanese</a></li> 
              <li><a class='request-language' id='Spanish'>Spanish</a></li> 
              <li><a class='request-language' id='French'>French</a></li> 
              <li><a class='request-language' id='German'>German</a></li> 
              <li><a class='request-language' id='Italian'>Italian</a></li> 
              <li><a class='request-language' id='Norwegian'>Norwegian</a></li> 
              <li><a class='request-language' id='Hebrew'>Hebrew</a></li> 
              <li><a class='request-language' id='Arabic'>Arabic</a></li> 
              <li><a class='request-language' id='Persian'>Persian</a></li> 
              <li><a class='request-language' id='Hindi'>Hindi</a></li></ul></li></ul>")

  # WHEN A NEW VIDEO URL GETS PASTED IN

  $("#new-video-submit").keyup =>
    user_submit = $("#new-video-submit").val()

    # VALIDATING THE URL AGAINST YOUTUBE SYNTAX 
    youtube_id = "#{user_submit}".replace 'http://www.youtube.com/watch?v=', ''
    window.youtube_id = "#{youtube_id}"
    if youtube_id.match(/&list/)
      youtube_id = youtube_id.slice(0,11)
      window.youtube_id = "#{youtube_id}"
    if youtube_id.match(/player_embedded/)
      youtube_id = youtube_id.replace 'http://www.youtube.com/watch?feature=player_embedded&v=', ''
      window.youtube_id = "#{youtube_id}"
    if youtube_id.match(/endscreen/)
      youtube_id = youtube_id.replace 'http://www.youtube.com/watch?feature=endscreen&NR=1&v=', ''
      window.youtube_id = "#{youtube_id}"

    if (window.keyup isnt 'done') and (user_submit.match(/youtube/) isnt null)
      window.keyup = 'done'

      # GET TITLE FROM YOUTUBE

      getTitle = (data) ->
        window.title = data.entry.title.$t
        $('#title-box').html("<h2>#{window.title}</h2>")

      getTitleFromYouTube = (handleData) ->
        $.get('https://gdata.youtube.com/feeds/api/videos/' + youtube_id + '?v=2&alt=json', 
          (data) ->
            handleData(data) )

      getTitleFromYouTube(getTitle)
      
      $("#copy-and-paste-box").slideUp('slow')

      if window.lang1 != undefined
        step2()

  # LANG1 SELECTOR 

  $(".video-language").livequery ->
    $(this).click ->
      window.lang1 = this.id
      if window.title == undefined
        $("#video-language-options").html("<a class='btn btn-info backtrack center-pill' id='video-lang-choice'>#{lang1}</a>")
      else
        step2()

  $('.backtrack#video-lang-choice').livequery ->
    $(this).click ->
      $('#video-language-dropdown').html('<p>This video is in:</p>
      <ul class="nav nav-pills" id="video-language-options">
        <li class="dropdown"> 
          <a data-toggle="dropdown" class="dropdown-toggle center-pill">Select language<b class="caret"></b></a> 
          <ul class="dropdown-menu" id="menu1">
            <li><a class="video-language" id="English">English</a></li> 
            <li><a class="video-language" id="Chinese">Chinese</a></li>
            <li><a class="video-language" id="Korean">Korean</a></li> 
            <li><a class="video-language" id="Japanese">Japanese</a></li> 
            <li><a class="video-language" id="Spanish">Spanish</a></li> 
            <li><a class="video-language" id="French">French</a></li> 
            <li><a class="video-language" id="German">German</a></li> 
            <li><a class="video-language" id="Italian">Italian</a></li> 
            <li><a class="video-language" id="Norwegian">Norwegian</a></li> 
            <li><a class="video-language" id="Hebrew">Hebrew</a></li> 
            <li><a class="video-language" id="Arabic">Arabic</a></li> 
            <li><a class="video-language" id="Persian">Persian</a></li> 
            <li><a class="video-language" id="Hindi">Hindi</a></li></ul></li></ul>')

  $(".request-language").livequery ->
    $(this).click ->
      window.lang2 = this.id
      if window.lang1 != window.lang2

        $("#request-language-options").html("<a class='btn btn-primary'>#{window.lang2}</a>")

        # TALK TO THE SERVER HERE

        $.post('/new_request', { 'request' : { 'video_id' : "#{window.video_id}" , 'lang2' : "#{window.lang2}", 'user_id' : "#{window.user_id}" } }, (data) ->
            window.request_id = data.data.id)

  $(".new-interp-language").livequery ->
    $(this).click ->
      window.lang2 = this.id
      if window.lang1 != window.lang2

        # TALK TO THE SERVER HERE

        $.post('/new_interp', { 'interpretation' : { 'youtube_id' : "#{window.youtube_id}" , 'lang1' : "#{lang1}", 'lang2' : "#{lang2}", 'user_id' : "#{window.user}" } }, (data) ->
            window.interp_id = data.data.id
            console.log window.interp_id)

        $("#video-language-dropdown").html("<br><br>
          <p><i>Got it!  One more:</i></p>  
          <br>
          <div class='center-pill-wide'><ul class='nav nav-pills'>
            <li><a id='just-lang2' class='translation-type-option'>I want to write out just the #{window.lang2} translation.</a></li>
            <br><br><br><br>
            <li><a id='lang1-and-lang2' class='translation-type-option'>I want to write out the #{window.lang2} and the #{window.lang1} side-by-side.</a></<ul></div>").slideDown()
        $("#translation-language-dropdown").html('')

        slowSplashPageContent = ->
          $("#select-language-box").html('<br><br>
            <a class="btn btn-info btn-large center-pill-wide" id="lets-get-going">Okay, let\'s get going!</a>').slideDown()
          $("#select-language-box").attr('id','splash-box')

        $("#lang1-and-lang2").livequery ->
          $(this).click ->
            window.translation_type = 'lang1_and_lang2'

        $("#just-lang2").livequery ->
          $(this).click ->
            window.translation_type = 'just_lang2'

        $(".translation-type-option").livequery ->
          $(this).click ->
            slowSplashPageContent()

  # SPLASH PAGE HERE

  $("#lets-get-going").livequery ->
    $(this).click ->
      $("#splash-box").hide()

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

        window.player = player

      onPlayerReady = (event) ->
        event.target.pauseVideo()

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

        # CALCULATING THE CURRENT LOOP START POINT IN INTEGER AND MM:SS FORMATS 
        current_loop_time = window.loop * window.section
        loop_minutes = Math.floor(current_loop_time / 60)
        if loop_minutes < 10
          loop_minutes = '0' + loop_minutes
        loop_seconds = current_loop_time - loop_minutes * 60
        if loop_seconds < 10
          loop_seconds = '0' + loop_seconds

        # CALCULATING LOOP END POINT IN INTEGER AND MM:SS FORMATS 
        current_loop_end = window.loop * (window.section + 1)
        loop_end_minutes = Math.floor(current_loop_end / 60)
        if loop_end_minutes < 10
          loop_end_minutes = '0' + loop_end_minutes
        loop_end_seconds = current_loop_end - (loop_end_minutes * 60)
        if loop_end_seconds < 10
          loop_end_seconds = '0' + loop_end_seconds

        # DISPLAYING THE TIMING ABOVE THE TRANSLATION INPUT LINES 
        if window.loop != false
          $(".current-loop-time").html(loop_minutes + ":" + loop_seconds + " to " + loop_end_minutes + ":" + loop_end_seconds)
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

      # PLAYER SETTINGS ADDED

      $("#controls").append('<div class="btn-group" id="settings-and-pin">
          <a class="btn btn-info dropdown-toggle" data-toggle="dropdown" id="settings"><i class="icon-cog icon-2x"></i></a></span>
            <ul class="dropdown-menu">
              <li><a id="timer-toggle">Turn big timer on/off</a></li>
              <li><a id="rollover-toggle">Pause video on mouse rollover</a></li></ul>
          <a class="btn btn-info" id="pin"><i class="icon-pushpin icon-2x"></i></a>
        </div>
        <div class="btn-group" id="forward-and-backward">
          <a class="btn btn-info dropdown-toggle" data-toggle="dropdown" id="loop-length"><i class="icon-refresh icon-2x"></i></a></span>
          <ul class="dropdown-menu">
            <li><a id="no-loop">No loop</a></li>
            <li><a id="loop-2">2 seconds</a></li>
            <li><a id="loop-4">4 seconds</a></li>
            <li><a id="loop-8">8 seconds</a></li></ul>
          <a class="btn btn-info" id="backward"><i class="icon-step-backward icon-2x"></i></a>
          <a class="btn btn-info" id="forward"><i class="icon-step-forward icon-2x"></i></a>
        </div>')
      $("#controls").prepend('<p id="red-arrow-text">Click here when the words start. Let\'s get translating!</p>')
      $("#red-arrow-text").hide()

      delayedShow = -> 
        
        # DONE, SHOW BUTTONS, TIMER BOX
        
        $(".very-wide-box").slideDown('')

        window.player.playVideo()

        # $('.done-button').html('<div class="btn btn-info" id="done-button">Done</div>')
        # $('.save-button').html('<div class="btn btn-info" id="save-button">Save</div>')
        $('#timer-box').html('<div id="timer"><h2 class="timer-text" id="big-timer"></h2></div>')
        $('#timer-box').hide()
        $("#controls").show()
        $("#red-arrow-text").show().effect('highlight',[],2000)
        $('#forward-and-backward').hide()

      window.setTimeout(delayedShow, 1500)

      $("#select-language-box").show()

      # PLAYER SETTINGS DEFINED 

      $("#pin").livequery ->
        $(this).click -> 
          $('#forward-and-backward').show()
          $("#pin").attr('class', 'btn btn-warning')
          window.section = window.time / 4
          window.loop = 4
          $('#timer-box').show()
          $('#red-arrow').fadeOut(2000)
          $('#red-arrow-text').fadeOut(2000)

          newRedArrow = ->
            console.log "New red arrow!!!"
            $('#red-arrow').attr('class','shift-right').attr('style','display: inline;')
            $('#red-arrow-text').attr('class','shift-right').attr('style','display: inline;')
            $('#red-arrow-text').html('Use these tools to find the best loop for your video.')
            redArrowFade = ->
              console.log "Red arrow fade!!!"
              $('#red-arrow').fadeOut(2000)
              $('#red-arrow-text').fadeOut(2000)
            window.setTimeout(redArrowFade, 5000) 
            $('#red-arrow').show()
            $('#red-arrow-text').show()
          window.setTimeout(newRedArrow, 3000)

          # LOGIC FOR THE INPUT LINES

          if window.translation_type == 'lang1_and_lang2'

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
                  $('.lang1-line').focus()
                  time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
                  $.post('/new_line', { 'line' : { 'lang1' : "#{that_entry}", 'lang2' : "#{entry}", 'time' : "#{time_in_seconds}", 'interpretation_id' : "#{window.interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
                    console.log data.data )
                  window.section += 1

          if window.translation_type == 'just_lang2'

            $(".lang2-line").livequery ->
              $(this).keyup (e) ->
                if e.which == 13
                  entry = this.value
                  console.log entry
                  if entry != ''
                    time = $("#current-loop-time").text()
                    $('#lang2-lyrics').append("<p><small><small>(#{time})</small></small>  #{entry}</p>")
                    $('.lang2-line').val('')
                    time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
                    $.post('/new_line', { 'line' : { 'lang1' : '', 'lang2' : "#{entry}", 'time' : "#{time_in_seconds}", 'interpretation_id' : "#{window.interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
                      console.log data.data )
                  window.section += 1

        # INPUT LINES COME IN HERE

          if window.translation_type == 'just_lang2'
            $('#lang2-input').html("<i class='left'>#{window.lang2}&nbsp;</i><small class='left'>(<small id='current-loop-time' class='current-loop-time'></small>)</small><br><div class='control-group'><div class='controls'><input type='text' class='input-xlarge lang2-line'></div></div>")

            # AND WIDTHS GET ADJUSTED DEPENDING ON IF ONE OR BOTH LANGUAGES ARE BEING TRANSCRIBED
            $('#lang1-box').parent().attr('class','')
            $('#lang2-box').parent().attr('class','lyrics-container wide')

          if window.translation_type == 'lang1_and_lang2'
            $('#lang1-input').html("<i class='left'>#{window.lang1}&nbsp;</i><small class='left'>(<small class='current-loop-time'></small>)</small><div class='control-group'><div class='controls'><input type='text' class='input-xlarge lang1-line'></div></div>")
            $('#lang2-input').html("<i class='left'>#{window.lang2}&nbsp;</i><small class='left'>(<small id='current-loop-time' class='current-loop-time'></small>)</small><div class='controls'><input type='text' class='input-xlarge lang2-line'></div>")

      # LOGIC FOR THE CONTROLS PANEL

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

# DONE BUTTON RESPONSE

  $("#done-button").livequery ->
    $(this).click -> 
      # video_lang = $("#video-lang-choice").click()
      # console.log video_lang
      # translation_lang = $("#translation-lang-choice").click()
      # console.log translation_lang
      
      # window.location.href = "http://localhost:3000/welcome/?video_lang=#{video_lang}&translation_lang=#{translation_lang}"