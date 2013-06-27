$ ->

  youtube_id = $('#youtube-id').html()
  lang1 = $('#lang1').html()
  lang2 = $('#lang2').html()
  if $('#user-id').attr('data-user') isnt 'logged-out'
    window.user_id = $('#user-id').attr('data-user')
  else
    window.user_id = null

  $('#title-box').hide()
  $('#red-arrow').hide()
  $('#title-box').slideDown('5000')
  $('#timer-box').html('<div id="timer"><h2 class="timer-text" id="big-timer"></h2></div>')
  $('#timer-box').hide()
  $("#controls").append('<br><div class="btn-group relative" id="settings-and-start">
      <br><br><br><br>
      <a class="btn btn-info btn-large center-pill rounded" id="start" style="position: absolute; left: 108px;">Start translating</a>
    </div>')
  $("#controls").prepend('<div id="red-arrow-text-box"><p><strong>Click here when <br> the words start!</strong></p></div>')
  $("#controls").fadeIn('slow')
  $('#red-arrow').fadeIn('slow')

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
    if event.data == YT.PlayerState.PAUSED
      exact_time = player.getCurrentTime()
      window.time = Math.round(exact_time)
      window.section = window.time / window.loop

  delayedShow = -> 
    window.player.playVideo()
  window.setTimeout(delayedShow, 1000)
    
  # PRESSING START

  $("#start").livequery ->
    $(this).click -> 
      window.player.pauseVideo()

      $(this).remove()
      $('#timer-box').show()
      $("#controls").html("
        <h3><i>So. How are we doing this translation?</i></h3>
          <label class='checkbox'>
            <input type='checkbox' id='lang1-and-lang2'>I want to write down the #{lang1} and #{lang2} side-by-side.
          </label>
          <label class='checkbox'>
            <input type='checkbox' id='just-lang2'>I want to just write down the #{lang2}.
          </label>
          <br>
          <h3><i>It's hard to translate at the same speed as the video.</i></h3>
          <label class='checkbox'>
            <input type='checkbox' id='normal'>Play the video at normal pace.
          </label>
          <label class='checkbox'>
            <input type='checkbox' id='loops'>Play it in loops.
          </label>
        <div class='btn-group' id='loop-settings'>
          <br>
          <a class='btn btn-info rounded' id='loop-2'>2s</a>
          <a class='btn btn-info rounded' id='loop-4'>4s</a>
          <a class='btn btn-info rounded' id='loop-8'>8s</i></a>
        </div>")
      $('#red-arrow-text-box').fadeOut(1500)
      $('#red-arrow').fadeOut(1500)
      newRedArrowText = ->
        $('#red-arrow-text-box').fadeIn()
        $('#red-arrow').fadeIn()
        $('#red-arrow-text-box').html('<br><p><strong>We\'ll play the video in 4-second loops for you. That makes translating easier and gives you more time to type.</p></strong>')
        $('#red-arrow').replaceWith('<img alt="red_arrow_flipped" id="red-arrow" src="/assets/red_arrow_flipped.png">')
        $('#red-arrow').attr('class','shifted')
        $('#red-arrow-text-box').attr('class','shifted')
      window.setTimeout(newRedArrowText, 1600)

      # FIRST LINE FOR THE QUIET TIME AT THE FRONT OF THE VIDEO
      time = $("#current-loop-time").text()
      time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
      $.post('/new_line', { 'line' : { 'lang1' : '', 'lang2' : '', 'time' : "#{time_in_seconds}", 'interpretation_id' : "#{window.interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
        console.log data.data )

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


  # LOGIC FOR THE CONTROLS PANEL

  $("#play-in-loops").livequery -> 
    $(this).click ->
      if $(this).attr('class') == 'btn btn-info off'
        $(this).attr('class', 'btn btn-warning on')
        $(this).html('<i>Playing video in loops</i>')
        $("#loop-4").attr('class','btn btn-warning')
        window.section = window.time / 4
        window.loop = 4
        window.player.playVideo()
        $('#red-arrow-text-box').fadeOut(1500)
        $('#red-arrow').fadeOut(1500)
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

# DONE/SAVE BUTTONS

  $("#done-button").livequery ->
    $(this).click ->
      if $("#user-id").attr('data-user') != "logged-out"
        $.post('/publish', { 'interpretation' : { 'id' : "#{window.interp_id}" } }, (data) ->
          console.log data.data )
        window.location.href = "/interpretations/#{window.interp_id}"
      else
        $('.save-button').hide()
        $('.done-button').html("<p><a href='/sign_up?interp=#{window.interp_id}'><strong>Sign up for Heyu?</strong></a> That way your username will appear alongside your translation. Get props for excellent work!<br><br> Otherwise, <a href='/interpretations/#{window.interp_id}'>submit your translation anonymously.</a>")

  $("#save-button").livequery ->
    $(this).click ->
      if $("#user-id").attr('data-user') != "logged-out"
        window.location.href = "/users/#{$("#user-id").attr('data-user')}"
      else
        window.location.href = "/sign_up"

# YOUTUBE WINDOW STICKY ON SCROLL

  $window = $(window)
  video_box = $('#outer-video-box')
  video_top = video_box.offset().top
  lyrics_container = $('.lyrics-container')
  $window.scroll ->
    video_box.toggleClass('sticky', $window.scrollTop() > video_top)
    lyrics_container.toggleClass('sticky', $window.scrollTop() > video_top)

