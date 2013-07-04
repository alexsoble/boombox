$ ->

  youtube_id = $('#youtube-id').html()
  lang1 = $('#lang1').html()
  lang2 = $('#lang2').html()
  interp_id = $('#interp-id').html()
  action_name = $('#action-name').html()

  formatTime = (time) ->
    time = Math.floor(time)
    if time <= 9 then formatted_time = "00:0" + time
    if 9 < time <= 59 then formatted_time = "00:" + time
    if 60 <= time < 540
      if time%60 <= 9 then formatted_time = "0" + Math.floor((time)/60) + ":0" + (time)%60
      if 9 < time%60 <= 59 then formatted_time = "0" + Math.floor((time)/60) + ":" + (time)%60
    if 540 <= time < 3600
      if time%60 <= 9 then formatted_time = Math.floor((time)/60) + ":0" + (time)%60
      if 9 < time%60 <= 59 then formatted_time = Math.floor((time)/60) + ":" + (time)%60
    formatted_time

  if action_name isnt 'edit'

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
    event.target.playVideo()

  window.section = 0 
  window.time = 0
  window.loop = 'none_yet'

  countVideoPlayTime = ->
    exact_time = player.getCurrentTime()
    window.time = Math.floor(exact_time)
    minutes = Math.floor(window.time / 60)
    $(".timer-text").html(formatTime(window.time))

    current_loop_time = window.loop * window.section
    current_loop_end = window.loop * (window.section + 1)

    # DISPLAYING THE TIMING ABOVE THE TRANSLATION INPUT LINES 
    if window.loop != false
      $(".current-loop-time").html(formatTime(current_loop_time) + " to " + formatTime(current_loop_end))
    else
      $(".current-loop-time").html(minutes + ":" + seconds)

    # LOOPING HAPPENS HERE
    if window.loop != false
      looping = ->
        player.seekTo(window.loop * window.section, true)
      if exact_time > (window.loop) * (window.section + 1) - .25 
        window.setTimeout(looping, 800)

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

  if action_name is 'edit'
    window.section = window.time / 4
    window.loop = 4
    window.translation_type = 'lang1_and_lang2'

  $("#yes-loops").livequery ->
    $(this).click -> 
      window.section = window.time / 4
      window.loop = 4
      $(this).parent().parent().fadeOut()
      step2()

  $("#no-loops").livequery ->
    $(this).click -> 
      $(this).parent().parent().fadeOut()
      step2()

  step2 = ->

    # HELLO ARRAY

    helloArray = []
    helloArray['Spanish'] = 'Hola'
    helloArray['French'] = 'Bonjour'
    helloArray['Italian'] = 'Ciao'
    helloArray['Portuguese'] = 'Oi'
    helloArray['Romanian'] = 'Bună ziua'
    helloArray['Catalan'] = 'Hola'
    helloArray['Korean'] = '안녕하세요'
    helloArray['Chinese'] = '你好'
    helloArray['Japanese'] = 'こんにちは'
    helloArray['Arabic'] = 'سلام'
    helloArray['Persian'] = 'سلام'
    helloArray['Urdu'] = 'سلام'
    helloArray['Turkish'] = 'Merhaba'
    helloArray['Hebrew'] = 'שלום'
    helloArray['Dutch'] = 'Hallo'
    helloArray['German'] = 'Guten Tag'
    helloArray['Afrikaans'] = 'Hallo'
    helloArray['Norwegian'] = 'Hei'
    helloArray['English'] = 'Hello'
    helloArray['Danish'] = 'Hej'
    helloArray['Icelandic'] = 'Halló'
    console.log helloArray

    $("#controls").html("
        <h3>One more question...</h3>
        <div style='margin: 30px;'>
          <label class='checkbox'>
            <input type='checkbox' id='lang1-and-lang2'>I want to write down the #{lang1} and #{lang2} side-by-side.
          <br>
          <div style='float: left; margin-left: 100px; margin-top: 25px;'><i>#{lang1}</i>: <br> #{helloArray[lang1]}</div>
          <div style='float: left; margin-left: 100px; margin-top: 25px;'><i>#{lang2}</i>: <br> #{helloArray[lang2]}</div>
          </label>
          <br>
        </div>
        <br>
        <div style='margin: 30px;'>
          <label class='checkbox'>
            <input type='checkbox' id='just-lang2'>I want to just write down the #{lang2} translation.
          </label>
          <br>
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
  
  step4 = ->
    console.log "Step 4 is occurring!!"
    $('.span7').remove()
  
    if window.translation_type == 'lang1_and_lang2' and action_name isnt 'edit'

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

    if window.translation_type == 'just_lang2' and action_name isnt 'edit'

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
            time = $("#current-loop-time").text()
            time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
            $.post('/new_line', { 'line' : { 'lang1' : "#{entry}", 'lang2' : "#{that_entry}", 'time' : "#{time_in_seconds}", 'duration' : "#{window.loop}", 'interpretation_id' : "#{interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
              line_id = data.data.id 
              duration = data.data.duration
              $('#lang1-lyrics').append("<p data-line-id=#{line_id} data-time=#{time_in_seconds} data-duration=#{duration}><small><small class='edit-duration'>(#{time})</small></small>  <span class='edit-line-lang1'>#{entry}</span></p>")
              $('#lang2-lyrics').append("<p data-line-id=#{line_id} data-time=#{time_in_seconds} data-duration=#{duration}><small><small class='edit-duration'>(#{time})</small></small>  <span class='edit-line-lang2'>#{that_entry}</span></p>")
              console.log data)
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
            time = $("#current-loop-time").text()
            time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
            $.post('/new_line', { 'line' : { 'lang1' : "#{that_entry}", 'lang2' : "#{entry}", 'time' : "#{time_in_seconds}", 'duration' : "#{window.loop}", 'interpretation_id' : "#{interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
              line_id = data.data.id 
              duration = data.data.duration
              $('#lang1-lyrics').append("<p data-line-id=#{line_id} data-time=#{time_in_seconds} data-duration=#{duration}><small><small class='edit-duration'>(#{time})</small></small>  <span class='edit-line-lang1'>#{that_entry}</span></p>")
              $('#lang2-lyrics').append("<p data-line-id=#{line_id} data-time=#{time_in_seconds} data-duration=#{duration}><small><small class='edit-duration'>(#{time})</small></small>  <span class='edit-line-lang2'>#{entry}</span></p>")
              console.log data)
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
              $.post('/new_line', { 'line' : { 'lang1' : '', 'lang2' : "#{entry}", 'time' : "#{time_in_seconds}", 'duration' : "#{window.loop}", 'interpretation_id' : "#{interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
                console.log data.data )
            window.section += 1
            $('.done-button').html('<div class="btn btn-info" id="done-button">Done</div>')
            $('.save-button').html('<div class="btn btn-info" id="save-button">Saving...</div>')
            delayedShowSaved = ->
              $('.save-button').html('<div class="btn btn-info" id="save-button">Saved</div>')
            window.setTimeout(delayedShowSaved, 600)

  step3 = ->

    if window.loop == false
      step4()

    if window.loop isnt false
      $('#loop-settings').html("
        <br>
        <a class='btn btn-info btn-small rounded' id='loop-status'>Playing in 4-second loops.</a>
        <div id='loop-slider'></div>
        <br>
        <br>
        <div class='btn-group'>
          <a class='btn btn-info btn-small rounded' id='backward-loop'><i class='icon-step-backward'></i> 1 loop</a>
          <a class='btn btn-info btn-small rounded' id='forward-loop'>1 loop <i class='icon-step-forward'></i></a>
          <br>
          <a class='btn btn-info btn-small rounded' id='backward-s' style='width: 48px;'><i class='icon-step-backward'></i> 1 sec. </a>
          <a class='btn btn-info btn-small rounded' id='forward-s' style='width: 48px;'>1 sec.  <i class='icon-step-forward'></i></a>
        </div>")
      $('#loop-slider').slider(
        min: 2
        max: 12
        step: 1
        value: 4
        slide: (event, ui) ->
          loopLength = ui.value
          window.loop = loopLength
          window.section = window.time / loopLength
          $("#loop-status").html("Playing in #{ui.value} second loops.")
          window.loop_handle.html("#{ui.value}")
        )
      window.loop_handle = $(".ui-slider-handle:eq(0)")
      window.loop_handle.html("4")
      step4()
    
  if action_name is 'edit'
    step3()

  # LOGIC FOR THE CONTROLS 

  $("#forward-loop").livequery ->
    $(this).click -> 
      window.section += 1
      player.seekTo(window.loop * window.section, true)

  $("#backward-loop").livequery ->
    $(this).click -> 
      window.section -= 1
      player.seekTo(window.loop * window.section, true)

  $("#forward-s").livequery ->
    $(this).click -> 
      player.seekTo((window.loop * window.section) + 1)
      window.section = window.section + 1/(window.loop)

  $("#backward-s").livequery ->
    $(this).click -> 
      player.seekTo((window.loop * window.section) - 1)
      window.section = window.section - 1/(window.loop)

  $('#loop-status').livequery -> 
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
          console.log updated_lang1 
          $(this).parent().parent().parent().attr('style','background-color: white;') )
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
          console.log updated_lang2
          $(this).parent().parent().parent().attr('style','background-color: white;') )
        window.editing_line = 'off'

  # REVISING TIME/DURATION OF LINES

  $('.edit-duration').livequery ->
    $(this).hover(
      -> $(this).attr('style','background-color: yellow;')
      -> $(this).attr('style','background-color: white;'))

    $(this).click ->

      if window.editing_line isnt 'on'

        $(this).parent().parent().append("
          <div id='editing-div'>
            <div id='slider'></div>
            <div id='revise-timing-done'><div class='btn btn-info btn-small rounded' id='editing-line-done'>Done!</div></div>
            <br>
          </div>")

        id = $('#editing-div').parent().attr('data-line-id')
        window.this_editing_time = $("[data-line-id=#{id}]:eq(0)").children(":first").children(":first")
        window.that_editing_time = $("[data-line-id=#{id}]:eq(1)").children(":first").children(":first")

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
            formatted_end_time = formatTime(ui.values[1])
            window.new_start_time = ui.values[0]
            window.new_end_time = ui.values[1]
            window.this_editing_time.html("(#{formatted_start_time} to #{formatted_end_time})")
            window.that_editing_time.html("(#{formatted_start_time} to #{formatted_end_time})")
            window.first_handle.html("<p><small><small>#{formatted_start_time}</small></small></p>")
            window.second_handle.html("<p><small><small>#{formatted_end_time}</small></small></p>"))

        window.first_handle = $(".ui-slider-handle:eq(1)")
        window.first_handle.html("<p><small><small>#{formatTime(old_start_time)}</small></small></p>")
        window.second_handle = $(".ui-slider-handle:eq(2)")
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

  # OLD STUFF...  MAYBE NOT USELESS THOUGH? 

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