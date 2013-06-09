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
      console.log data
      window.video_id = data.video.id )

    $("#select-language-box").slideDown('slow')

    if window.request == false
      $('#translation-language-dropdown').html("<br><br>
        <p>I\'m translating it into:</p>
        <ul class='nav nav-pills' id='language-options'>
          <li class='dropdown'>
            <a class='btn btn-info dropdown-toggle center-pill' data-toggle='dropdown'>Select language<b class='caret'></b></a> 
              <ul class='dropdown-menu'>
              <li><a class='interp-language' id='English'>English</a></li> 
              <li><a class='interp-language' id='Chinese'>Chinese</a></li>
              <li><a class='interp-language' id='Korean'>Korean</a></li> 
              <li><a class='interp-language' id='Japanese'>Japanese</a></li> 
              <li><a class='interp-language' id='Spanish'>Spanish</a></li> 
              <li><a class='interp-language' id='Portuguese'>Portuguese</a></li> 
              <li><a class='interp-language' id='French'>French</a></li> 
              <li><a class='interp-language' id='German'>German</a></li> 
              <li><a class='interp-language' id='Italian'>Italian</a></li> 
              <li><a class='interp-language' id='Russian'>Russian</a></li> 
              <li><a class='interp-language' id='Norwegian'>Norwegian</a></li> 
              <li><a class='interp-language' id='Hebrew'>Hebrew</a></li> 
              <li><a class='interp-language' id='Arabic'>Arabic</a></li> 
              <li><a class='interp-language' id='Persian'>Persian</a></li> 
              <li><a class='interp-language' id='Hindi'>Hindi</a></li></ul></li></ul>")

    if window.request == true
      $('#translation-language-dropdown').html("<br><br>
        <p>I\'d like a translation of this video into:</p>
        <ul class='nav nav-pills' id='request-options'>
          <li class='dropdown'>
            <a class='btn btn-info dropdown-toggle center-pill' data-toggle='dropdown'>Select language<b class='caret'></b></a> 
              <ul class='dropdown-menu'>
              <li><a class='request-language' id='English'>English</a></li> 
              <li><a class='request-language' id='Chinese'>Chinese</a></li>
              <li><a class='request-language' id='Korean'>Korean</a></li> 
              <li><a class='request-language' id='Japanese'>Japanese</a></li> 
              <li><a class='request-language' id='Spanish'>Spanish</a></li> 
              <li><a class='request-language' id='Portuguese'>Portuguese</a></li> 
              <li><a class='request-language' id='French'>French</a></li> 
              <li><a class='request-language' id='German'>German</a></li> 
              <li><a class='request-language' id='Italian'>Italian</a></li> 
              <li><a class='request-language' id='Russian'>Russian</a></li> 
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
    youtube_id = youtube_id.replace 'https://www.youtube.com/watch?v=', ''
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
      $("#language-options").html("<a class='btn btn-info backtrack center-pill' id='video-lang-choice'>#{lang1}</a>")
      if window.title != undefined
        step2()

  $('.backtrack#video-lang-choice').livequery ->
    $(this).click ->
      $('#video-language-dropdown').html('<p>This video is in:</p>
      <ul class="nav nav-pills" id="language-options">
        <li class="dropdown"> 
          <a data-toggle="dropdown" class="dropdown-toggle center-pill">Select language<b class="caret"></b></a> 
          <ul class="dropdown-menu" id="menu1">
            <li><a class="video-language" id="English">English</a></li> 
            <li><a class="video-language" id="Chinese">Chinese</a></li>
            <li><a class="video-language" id="Korean">Korean</a></li> 
            <li><a class="video-language" id="Japanese">Japanese</a></li> 
            <li><a class="video-language" id="Spanish">Spanish</a></li> 
            <li><a class="video-language" id="Spanish">Portuguese</a></li> 
            <li><a class="video-language" id="French">French</a></li> 
            <li><a class="video-language" id="German">German</a></li> 
            <li><a class="video-language" id="Italian">Italian</a></li> 
            <li><a class="video-language" id="Russian">Russian</a></li> 
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

        $('#select-language-box').html("
          <h2>Request submitted!</h2>
          <br>
          <p>#{window.title} into #{window.lang2}</p>
          <br>
          Browse other videos in <a href='/interpretations?lang=#{window.lang1}'>#{window.lang1}</a> or <a href='/interpretations?lang=#{window.lang2}'>#{window.lang2}?</a>")

        $('#video-language-dropdown').html('')

  $(".interp-language").livequery ->
    $(this).click ->
      window.lang2 = this.id
      if window.lang1 != window.lang2

        # TALK TO THE SERVER HERE
        $.post('/new_interp', { 'interpretation' : { 'video_id' : "#{window.video_id}" , 'lang2' : "#{window.lang2}", 'user_id' : "#{window.user_id}" } }, (data) ->
            window.interp_id = data.data.id )
        $('#translation-language-dropdown').hide()
        $('#video-language-dropdown').hide()
        $('#copy-and-paste-box').parent().remove()

        $("#select-language-box").html("<br><br>
          <p class='center'><i>Got it!  Which would you prefer?</i></p>  
          <br>
          <div class='center-pill-wide'><ul class='nav nav-pills'>
            <li><a id='just-lang2' class='translation-type-option'>I want to write out just the #{window.lang2} translation.</a></li>
            <br><br><br><br>
            <li><a id='lang1-and-lang2' class='translation-type-option'>I want to write out the #{window.lang2} and the #{window.lang1} side-by-side.</a></<ul></div>").slideDown()

        $("#lang1-and-lang2").livequery ->
          $(this).click ->
            window.translation_type = 'lang1_and_lang2'

        $("#just-lang2").livequery ->
          $(this).click ->
            window.translation_type = 'just_lang2'

        $(".translation-type-option").livequery ->
          $(this).click ->
            # $("#select-language-box").slideUp()
            # replaceContents = ->
            $("#select-language-box").html('<br><br><br><br><br><a class="btn btn-info btn-large center-pill-wide" id="lets-get-going">Okay, let\'s get going!</a>')
            # window.setTimeout(replaceContents, 400)
            # $("#select-language-box").slideDown()

  # YOUTUBE PLAYER COMES IN HERE

  $("#lets-get-going").livequery ->
    $(this).click ->
      $("#select-language-box").remove()
      $("#video-language-dropdown").slideUp()

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
        if event.data == YT.PlayerState.PAUSED
          exact_time = player.getCurrentTime()
          window.time = Math.round(exact_time)
          console.log window.time + "<---- window.time!"
          window.section = window.time / window.loop

      # PLAYER SETTINGS ADDED

      $("#controls").append('<br><div class="btn-group relative" id="settings-and-start">
          <a class="btn btn-info btn-large center-pill" id="start" style="position: absolute; left: 108px;">Start translating</a>
        </div>')
      
      # DONE, SHOW BUTTONS, TIMER BOX

      delayedShow = -> 
                
        $(".very-wide-box").slideDown('')
        window.player.playVideo()
        $('#timer-box').html('<div id="timer"><h2 class="timer-text" id="big-timer"></h2></div>')
        $('#timer-box').hide()
        $("#controls").show()
        $("#controls").prepend('<div id="red-arrow-text-box"><p><strong>Click when you hear the words start!</strong></p></div>')

      window.setTimeout(delayedShow, 1500)
      
      # PRESSING START

      $("#start").livequery ->
        $(this).click -> 
          $(this).remove()
          $('#timer-box').show()
          $("#controls").append('
            <div class="btn-group" id="loop-settings">
              <a class="btn btn-info off" id="play-in-loops">Play video in loops?</a>
              <a class="btn btn-info" id="loop-2">2s</a>
              <a class="btn btn-info" id="loop-4">4s</a>
              <a class="btn btn-info" id="loop-8">8s</i></a>
            </div>')
          $('#red-arrow-text-box').fadeOut(1500)
          $('#red-arrow').fadeOut(1500)

          # FIRST LINE FOR THE QUIET TIME AT THE FRONT OF THE VIDEO
          time = $("#current-loop-time").text()
          time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
          $.post('/new_line', { 'line' : { 'lang1' : '', 'lang2' : '', 'time' : "#{time_in_seconds}", 'interpretation_id' : "#{window.interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
                    console.log data.data )

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
                  $('.done-button').html('<div class="btn btn-info" id="done-button">Done</div>')
                  $('.save-button').html('<div class="btn btn-info" id="save-button">Save</div>').effect('highlight')

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
                  $('.done-button').html('<div class="btn btn-info" id="done-button">Done</div>')
                  $('.save-button').html('<div class="btn btn-info" id="save-button">Save</div>').effect('highlight')

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
                  $('.done-button').html('<div class="btn btn-info" id="done-button">Done</div>')
                  $('.save-button').html('<div class="btn btn-info" id="save-button">Saving...</div>')
                  delayedShowSaved = ->
                    $('.save-button').html('<div class="btn btn-info" id="save-button">Saved</div>')
                  window.setTimeout(delayedShowSaved, 600)

        # INPUT LINES COME IN HERE

          if window.translation_type == 'just_lang2'
            $('#lang2-input').html("<div><i class='left'>#{window.lang2}&nbsp;</i>
              <small class='left'>(<small id='current-loop-time' class='current-loop-time'></small>)</small></div>
              <br>
              <div class='control-group'>
                <div class='controls'>
                  <input type='text' class='input-xlarge lang2-line'>
                </div>
              </div>")

            # AND WIDTHS GET ADJUSTED DEPENDING ON IF ONE OR BOTH LANGUAGES ARE BEING TRANSCRIBED
            $('#lang1-box').parent().attr('class','')
            $('#lang2-box').parent().attr('class','lyrics-container wide')

          if window.translation_type == 'lang1_and_lang2'
            $('#lang1-input').html("<div><i class='left'>#{window.lang1}&nbsp;</i>
              <small class='left'>(<small class='current-loop-time'></small>)</small></div>
              <br>
              <div class='control-group'>
                <div class='controls'>
                  <input type='text' class='input-xlarge lang1-line'>
                </div>
              </div>")
            $('#lang2-input').html("<div><i class='left'>#{window.lang2}&nbsp;</i><small class='left'>
              (<small id='current-loop-time' class='current-loop-time'></small>)</small></div>
              <br>
              <div class='controls'>
                <input type='text' class='input-xlarge lang2-line'>
              </div>")

      # LOGIC FOR THE CONTROLS PANEL

      $("#play-in-loops").livequery -> 
        $(this).click ->
          if $(this).attr('class') == 'btn btn-info off'
            $(this).attr('class', 'btn btn-warning on')
            $(this).html('<i>Playing video in loops</i>')
            $("#loop-4").attr('class','btn btn-warning')
            window.section = window.time / 4
            window.loop = 4
          else
            $(this).attr('class', 'btn btn-info off')
            $(this).text('Play video in loops?')
            $("#loop-2").attr('class','btn btn-info')
            $("#loop-4").attr('class','btn btn-info')
            $("#loop-8").attr('class','btn btn-info')
            window.loop = false

      $("#loop-2").livequery ->
        $(this).click ->
          window.loop = 2
          window.section = window.time / 2
          $("#loop-2").attr('class','btn btn-warning')
          $("#loop-4").attr('class','btn btn-info')
          $("#loop-8").attr('class','btn btn-info')

      $("#loop-4").livequery ->
        $(this).click ->
          window.loop = 4
          window.section = window.time / 4
          $("#loop-2").attr('class','btn btn-info')
          $("#loop-4").attr('class','btn btn-warning')
          $("#loop-8").attr('class','btn btn-info')

      $("#loop-8").livequery ->
        $(this).click ->
          window.loop = 8
          window.section = window.time / 8
          $("#loop-2").attr('class','btn btn-info')
          $("#loop-4").attr('class','btn btn-info')
          $("#loop-8").attr('class','btn btn-warning')

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
      $.post('/publish', { 'interpretation' : { 'id' : "#{window.interp_id}" } }, (data) ->
        console.log data.data )
      window.location.href = "/interpretations/#{window.interp_id}"