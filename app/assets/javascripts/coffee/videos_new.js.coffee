$ ->

  youtube_id = $('#youtube-id').html()
  lang1 = $('#lang1').html()
  lang2 = $('#lang2').html()
  interp_id = $('#interp-id').html()

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
  window.loop = 'none_yet'

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

      # FIRST LINE FOR THE QUIET TIME AT THE FRONT OF THE VIDEO
      time = $("#current-loop-time").text()
      time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
      $.post('/new_line', { 'line' : { 'lang1' : '', 'lang2' : '', 'time' : "#{time_in_seconds}", 'interpretation_id' : "#{interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
        console.log data.data )

      $(this).remove()
      $('#timer-box').show()
      $("#controls").html("
      <div>
        <h3>Heads up: It's hard to translate at the same speed as the video.</h3>
        <label class='checkbox'>
          <input type='checkbox' id='yes-loops'>Yeah. Play each section of the video in a loop until I'm done translating it.
        </label>
        <label class='checkbox'>
          <input type='checkbox' id='no-loops'>I'm a pro. Play the video without looping.
        </label>
      </div>")

  $("#yes-loops").livequery ->
    $(this).click -> 
      window.section = window.time / 4
      window.loop = 4
      window.player.playVideo()
      $(this).parent().parent().fadeOut()
      $('#loop-settings').html("
        <div class='btn-group' id='loop-settings'>
          <br>
          <a class='btn btn-warning rounded' id='playing-in-loops'><i>Playing video in loops</i></a>
          <a class='btn btn-info rounded' id='loop-2'>2s</a>
          <a class='btn btn-warning rounded' id='loop-4'>4s</a>
          <a class='btn btn-info rounded' id='loop-8'>8s</i></a>
          <br>
          <br>
          <a class='btn btn-info rounded' id='backward'><i class='icon-step-backward'></i> Skip backward</a>
          <a class='btn btn-info rounded' id='forward'>Skip forward <i class='icon-step-forward'></i></a>
        </div>")
      step2()

  $("#no-loops").livequery ->
    $(this).click -> 
      window.loop = false
      window.player.playVideo()
      $(this).parent().parent().fadeOut()
      step2()

  step2 = ->
    $("#controls").html("
      <div>
        <h3>One more question.</h3>
        <label class='checkbox'>
          <input type='checkbox' id='lang1-and-lang2'>I want to write down the #{lang1} and #{lang2} side-by-side.
        </label>
        <label class='checkbox'>
          <input type='checkbox' id='just-lang2'>I want to just write down the #{lang2} translation.
        </label>
      </div>")

  $("#lang1-and-lang2").livequery ->
    $(this).click -> 
      window.translation_type = 'lang1_and_lang2'
      $(this).parent().parent().fadeOut()
      step3()

  $("#just-lang2").livequery -> 
    $(this).click ->
      window.translation_type = 'just_lang2'
      $(this).parent().parent().fadeOut()
      step3()

  step3 = ->

    $('.span7').remove()
  
    if window.translation_type == 'lang1_and_lang2'

      $('#lang1-input').html("<div><i class='left'>#{lang1}&nbsp;</i>
        <small class='left'>(<small class='current-loop-time'></small>)</small></div>
        <br>
        <div class='control-group'>
          <div class='controls'>
            <input type='text' class='input-xlarge lang1-line'>
          </div>
        </div>")
      $('#lang2-input').html("<div><i class='left'>#{lang2}&nbsp;</i>
        <small class='left'>(<small id='current-loop-time' class='current-loop-time'></small>)</small></div>
        <br>
        <div class='controls'>
          <input type='text' class='input-xlarge lang2-line'>
        </div>")

    if window.translation_type == 'just_lang2'

      $('#lang2-input').html("
        <div><i class='left'>#{lang2}&nbsp;</i>
          <small class='left'>(<small id='current-loop-time' class='current-loop-time'></small>)</small></div>
          <br>
          <div class='control-group'>
            <div class='controls'>
              <input type='text' class='input-xlarge lang2-line'>
            </div>
          </div>")

      $('#lang1-box').parent().parent().remove()

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
            time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
            $.post('/new_line', { 'line' : { 'lang1' : "#{entry}", 'lang2' : "#{that_entry}", 'time' : "#{time_in_seconds}", 'interpretation_id' : "#{interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
              line_id = data.data.id 
              duration = data.data.duration
              $('#lang1-lyrics').append("<p data-line-id=#{line_id} data-time=#{time_in_seconds} data-duration=#{duration}><small><small class='edit-duration'>(#{time})</small></small>  <span class='edit-line-lang1'>#{entry}</span></p>")
              $('#lang2-lyrics').append("<p data-line-id=#{line_id} data-time=#{time_in_seconds} data-duration=#{duration}><small><small class='edit-duration'>(#{time})</small></small>  <span class='edit-line-lang2'>#{that_entry}</span></p>"))
            $('.lang1-line').val('')
            $('.lang2-line').val('')
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
            time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
            $.post('/new_line', { 'line' : { 'lang1' : "#{that_entry}", 'lang2' : "#{entry}", 'time' : "#{time_in_seconds}", 'interpretation_id' : "#{interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
              line_id = data.data.id 
              duration = data.data.duration
              $('#lang1-lyrics').append("<p data-line-id=#{line_id} data-time=#{time_in_seconds} data-duration=#{duration}><small><small class='edit-duration'>(#{time})</small></small>  <span class='edit-line-lang1'>#{that_entry}</span></p>")
              $('#lang2-lyrics').append("<p data-line-id=#{line_id} data-time=#{time_in_seconds} data-duration=#{duration}><small><small class='edit-duration'>(#{time})</small></small>  <span class='edit-line-lang2'>#{entry}</span></p>"))
            window.section += 1
            $('.lang1-line').val('')
            $('.lang2-line').val('')
            $('.lang1-line').focus()
            $('.done-button').html('<div class="btn btn-info" id="done-button">Done</div>')
            $('.save-button').html('<div class="btn btn-info" id="save-button">Saving...</div>')
            delayedShowSaved = ->
              $('.save-button').html('<div class="btn btn-info" id="save-button">Saved</div>')
            window.setTimeout(delayedShowSaved, 600)

    if window.translation_type == 'just_lang2'

      $(".lang2-line").livequery ->
        $(this).keyup (e) ->
          if e.which == 13
            entry = this.value
            console.log entry
            if entry isnt ''
              time = $("#current-loop-time").text()
              $('#lang2-lyrics').append("<p><small><small class='edit-duration'>(#{time})</small></small>  <span class='edit-line-lan2'>#{entry}</span></p>")
              $('.lang2-line').val('')
              time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
              $.post('/new_line', { 'line' : { 'lang1' : '', 'lang2' : "#{entry}", 'time' : "#{time_in_seconds}", 'interpretation_id' : "#{interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
                console.log data.data )
            window.section += 1
            $('.done-button').html('<div class="btn btn-info" id="done-button">Done</div>')
            $('.save-button').html('<div class="btn btn-info" id="save-button">Saving...</div>')
            delayedShowSaved = ->
              $('.save-button').html('<div class="btn btn-info" id="save-button">Saved</div>')
            window.setTimeout(delayedShowSaved, 600)

  # REVISING LINE CONTENT 

  $('.edit-line-lang1').livequery ->
    $(this).hover(
      -> $(this).attr('style','background-color: yellow;')
      -> $(this).attr('style','background-color: white;'))

  $('.edit-line-lang2').livequery ->
    $(this).hover(
      -> $(this).attr('style','background-color: yellow;')
      -> $(this).attr('style','background-color: white;'))
 
  $('.edit-line-lang1').livequery ->
    $(this).click ->
      if window.editing_line isnt 'on'
        html = $(this).text()
        $(this).html("
          <div class='control-group'>
            <div class='controls'>
              <input type='text' class='input-xlarge' id='edit-line-lang1'>
            </div>
          </div>")
        $('#edit-line-lang1').val(html)
        window.editing_line = 'on'

  $('#edit-line-lang1').livequery ->
    $(this).keyup (e) ->
      e.preventDefault
      if e.which == 13 and this.value isnt ''
        entry = this.value
        line_id = $('#edit-line-lang1').parent().parent().parent().parent().attr('data-line-id')
        text_to_update = $('#edit-line-lang1').parent().parent().parent()
        $.post('/update_line', { 'line' : { 'lang1' : "#{entry}", 'id' : "#{line_id}" } }, (data) ->
          updated_lang1 = data.data.lang1
          text_to_update.html("#{updated_lang1}")
          console.log updated_lang1 )
        window.editing_line = 'off'

  $('.edit-line-lang2').livequery ->
    $(this).click ->
      if window.editing_line isnt 'on'
        html = $(this).text()
        $(this).html("
          <div class='control-group'>
            <div class='controls'>
              <input type='text' class='input-xlarge' id='edit-line-lang2'>
            </div>
          </div>")
        $('#edit-line-lang2').val(html)
        window.editing_line = 'on'

  $('#edit-line-lang2').livequery ->
    $(this).keyup (e) ->
      e.preventDefault
      if e.which == 13 and this.value isnt ''
        entry = this.value
        line_id = $('#edit-line-lang2').parent().parent().parent().parent().attr('data-line-id')
        text_to_update = $('#edit-line-lang2').parent().parent().parent()
        $.post('/update_line', { 'line' : { 'lang2' : "#{entry}", 'id' : "#{line_id}" } }, (data) ->
          updated_lang2 = data.data.lang2
          text_to_update.html("#{updated_lang2}")
          console.log updated_lang2 )
        window.editing_line = 'off'

  # REVISING TIME/DURATION OF LINES

  $('.edit-duration').livequery ->
    $(this).hover(
      -> $(this).attr('style','background-color: yellow;')
      -> $(this).attr('style','background-color: white;'))

    $(this).click ->

      formatTime = (time) ->
        if time <= 9 then formatted_time = "00:0" + time
        if 9 < time <= 59 then formatted_time = "00:" + time
        if 60 <= time then formatted_time = (time)/60 + ":" + (time)%60
        formatted_time

      if window.editing_line isnt 'on'

        $(this).parent().parent().append("
          <div id='editing-div'>
            <div id='slider'></div>
            <div id='revise-timing-done'><div class='btn btn-info btn-small rounded' id='editing-line-done'>Done!</div></div>
            <br>
          </div>")

        window.this_editing_time = $('#editing-div').parent().children(":first").children(":first")
        old_start_time = parseInt($('#slider').parent().parent().attr('data-time'))
        old_end_time = parseInt($('#slider').parent().parent().attr('data-time')) + parseInt($('#slider').parent().parent().attr('data-duration'))
        old_midpoint = Math.round((old_start_time + old_end_time) / 2)
        console.log "old start time: #{old_start_time}, old end time: #{old_end_time}"

        $('#slider').slider(
          range: true
          if old_end_time > 5
            min: old_midpoint - 5
          else
            min: 0
          max: old_midpoint + 6
          step: 1
          values: [ old_start_time, old_end_time ]
          slide: (event, ui) ->
            formatted_start_time = formatTime(ui.values[0])
            window.new_start_time = ui.values[0]
            formatted_end_time = formatTime(ui.values[1])
            window.new_end_time = ui.values[1]
            window.this_editing_time.html("(#{formatted_start_time} to #{formatted_end_time})")
            window.first_handle.html("<p><small><small>#{formatted_start_time}</small></small></p>")
            window.second_handle.html("<p><small><small>#{formatted_end_time}</small></small></p>"))

        window.first_handle = $(".ui-slider-handle:eq(0)")
        window.first_handle.html("<p><small><small>#{formatTime(old_start_time)}</small></small></p>")
        window.second_handle = $(".ui-slider-handle:eq(1)")
        window.second_handle.html("<p><small><small>#{formatTime(old_end_time)}</small></small></p>")
        $('#editing-div').hide().slideDown('fast')
      window.editing_line = 'on'

  $('#editing-line-done').livequery ->
    $(this).click ->
      line_id = $(this).parent().parent().parent().attr('data-line-id')
      line_to_update = $(this).parent().parent().parent()
      $.post('/update_line', { 'line' : { 'time' : "#{window.new_start_time}", 'duration' : "#{window.new_end_time - window.new_start_time}", 'id' : "#{line_id}" } }, (data) ->
        updated_time = data.data.time
        updated_duration = data.data.duration
        line_to_update.attr('data-time', "#{updated_time}")
        line_to_update.attr('data-duration', "#{updated_duration}")
        console.log "updated time: #{updated_time}, updated duration: #{updated_duration}" )
      $(this).parent().parent().slideUp()
      $(this).parent().parent().remove()
      window.editing_line = 'off'

  # LOGIC FOR THE CONTROLS PANEL

  $('#playing-in-loops').livequery -> 
    $(this).click ->
      if $(this).attr('class') == 'btn btn-warning rounded'
        console.log "Turning loops off."
        $(this).attr('class','btn btn-info rounded')
        $(this).html('Playing without loops')
        window.loop = false
        $("#loop-2").attr('class','btn btn-info rounded')
        $("#loop-4").attr('class','btn btn-info rounded')
        $("#loop-8").attr('class','btn btn-info rounded')
      else
        console.log "Turning loops on."
        $(this).attr('class','btn btn-warning rounded')
        $(this).html('<i>Playing video in loops</i>')
        window.loop = 4
        $("#loop-2").attr('class','btn btn-info rounded')
        $("#loop-4").attr('class','btn btn-warning rounded')
        $("#loop-8").attr('class','btn btn-info rounded')

  $("#loop-2").livequery ->
    $(this).click ->
      window.loop = 2
      window.section = window.time / 2
      $("#playing-in-loops").attr('class','btn btn-warning rounded')
      $("#playing-in-loops").html('<i>Playing video in loops</i>')
      $("#loop-2").attr('class','btn btn-warning rounded')
      $("#loop-4").attr('class','btn btn-info rounded')
      $("#loop-8").attr('class','btn btn-info rounded')

  $("#loop-4").livequery ->
    $(this).click ->
      window.loop = 4
      window.section = window.time / 4
      $("#playing-in-loops").attr('class','btn btn-warning rounded')
      $("#playing-in-loops").html('<i>Playing video in loops</i>')
      $("#loop-2").attr('class','btn btn-info rounded')
      $("#loop-4").attr('class','btn btn-warning rounded')
      $("#loop-8").attr('class','btn btn-info rounded')

  $("#loop-8").livequery ->
    $(this).click ->
      window.loop = 8
      window.section = window.time / 8
      $("#playing-in-loops").attr('class','btn btn-warning rounded')
      $("#playing-in-loops").html('<i>Playing video in loops</i>')
      $("#loop-2").attr('class','btn btn-info rounded')
      $("#loop-4").attr('class','btn btn-info rounded')
      $("#loop-8").attr('class','btn btn-warning rounded')

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
        $.post('/publish', { 'interpretation' : { 'id' : "#{interp_id}" } }, (data) ->
          console.log data.data )
        window.location.href = "/interpretations/#{interp_id}"
      else
        $('.save-button').hide()
        $('.done-button').html("<p><a href='/sign_up?interp=#{interp_id}'><strong>Sign up for Heyu?</strong></a> That way your username will appear alongside your translation. Get props for excellent work!<br><br> Otherwise, <a href='/interpretations/#{interp_id}'>submit your translation anonymously.</a>")

  $("#save-button").livequery ->
    $(this).click ->
      if $("#user-id").attr('data-user') != "logged-out"
        window.location.href = "/users/#{$("#user-id").attr('data-user')}"
      else
        $('.save-button').hide()
        $('.done-button').html("<p><a href='/sign_up?interp=#{interp_id}'><strong>Sign up for Heyu</strong></a> to save your translation.<br><br><a href='#' id='go-back'>Go back.</a>")

  $("#go-back").livequery -> 
    $(this).click -> 
        $('.save-button').show()
        $('.done-button').html('<div class="btn btn-info" id="done-button">Done</div>')

# YOUTUBE WINDOW STICKY ON SCROLL

  $window = $(window)
  video_box = $('#outer-video-box')
  video_top = video_box.offset().top
  lyrics_container = $('.lyrics-container')
  $window.scroll ->
    video_box.toggleClass('sticky', $window.scrollTop() > video_top)
    lyrics_container.toggleClass('sticky', $window.scrollTop() > video_top)