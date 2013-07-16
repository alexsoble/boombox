$ ->

  youtube_id = $('#data').attr('data-youtube-id')
  lang1 = $('#data').attr('data-lang-one')
  lang2 = $('#data').attr('data-lang-two')
  interp_id = $('#data').attr('data-interp-id')
  action_name = $('#data').attr('data-action-name')
  translation_type = $('#data').attr('data-translation-type')
  published = $('#data').attr('data-published')
  console.log youtube_id + " " + lang1 + " " + lang2 + " " + interp_id + " " + action_name + " "+ translation_type

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

  shortFormatTime = (time) ->
    time = Math.floor(time)
    if time <= 9 then formatted_time = ":0" + time
    if 9 < time <= 59 then formatted_time = ":" + time
    if 60 <= time < 540
      if time%60 <= 9 then formatted_time = Math.floor((time)/60) + ":0" + (time)%60
      if 9 < time%60 <= 59 then formatted_time = Math.floor((time)/60) + ":" + (time)%60
    if 540 <= time < 3600
      if time%60 <= 9 then formatted_time = Math.floor((time)/60) + ":0" + (time)%60
      if 9 < time%60 <= 59 then formatted_time = Math.floor((time)/60) + ":" + (time)%60
    formatted_time

  window.loop = false
  window.tool_helptip_displayed = false
  window.editing_line = 'off'
  $('#timer-box').html('<div id="timer"><h2 class="timer-text" id="big-timer"></h2></div>')

  if action_name is 'edit'
    $('.tools-container').toggle('width')
    if published is 'false'
      $('.preview-button').html('<div class="btn btn-info" id="preview-button">Preview</div>')
    if published is 'true'
      $('.publish-button').html('<div class="btn btn-info" id="publish-button">Update</div>')
  if action_name isnt 'edit'
    $('#title-box').hide()
    $('#red-arrow').hide()
    $('#title-box').slideDown('5000')
    $('#timer-box').hide()
    $("#controls").append('<br><div class="btn-group relative" id="settings-and-start">
        <br><br><br><br>
        <a class="btn btn-info btn-large center-pill rounded" id="start" style="position: absolute; left: 108px;">Start translating</a>
      </div>')
    $("#controls").prepend('<div id="red-arrow-text-box"><p><strong>Click here when <br> the words start!</strong></p></div>')
    $("#controls").fadeIn('slow')
    $('#red-arrow').fadeIn('slow')

  $("#start").livequery ->
    $(this).click -> 
      window.player.pauseVideo()

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
    window.translation_type = translation_type
    sliderSetup()
    nonLoopingSlider()

  $("#yes-loops").livequery ->
    $(this).click -> 
      window.section = window.time / 4
      window.loop = 4
      $(this).parent().parent().fadeOut()
      sliderSetup()
      loopingSlider()
      langOneLangTwoStep()

  $("#no-loops").livequery ->
    $(this).click -> 
      $(this).parent().parent().fadeOut()
      sliderSetup()
      nonLoopingSlider()
      langOneLangTwoStep()

  sliderSetup = ->

    $('#settings').append("
        <!---
        <div class='dropdown' id='difficulty-settings'>
          <a class='dropdown-toggle' data-toggle='dropdown' href='#'>Difficulty </a>
          <ul class='dropdown-menu'>
            <li><a href='#'>Beginner</a></li>
            <li><a href='#'>Intermediate</a></li>
            <li><a href='#'>Advanced</a></li>
          </ul>
        </li> -->
        <div id='loop-settings'>
          <div id='loop-slider'></div>
          <br>
          <span id='loop-status'>Playing in 4-second loops.</span> <a id='loop-toggle'><small>(off)</small></a>
        </div>
        ")

    window.start_handle = $(".ui-slider-handle:eq(0)")
    window.end_handle = $(".ui-slider-handle:eq(1)")

  loopingSlider = ->
    $('#loop-slider').rangeSlider(
      arrows: false
      step: 1
      defaultValues:
        min: 0
        max: 4
      bounds:
        min: 0
        max: 60
      range:
        min: 1
        max: 12
      formatter: (val) -> 
        shortFormatTime(val)
      valueLabels: "change"
      durationIn: 1200
      durationOut: 1200
      ).bind("valuesChanged", (e, data) ->
        start = data.values.min
        end = data.values.max
        player.seekTo(start)
        window.loop = end - start
        window.section = start / window.loop
        $("#loop-status").html("Playing in a loop from #{shortFormatTime(start)} to #{shortFormatTime(end)}.")
      )

  nonLoopingSlider = ->
    $('#loop-slider').slider(
      range: false
      min: 0
      max: 60
      step: 1
      values: 0
      slide: (event, ui) ->
        start = ui.value
        window.start_handle.html("<div class='loop-start-handle'><small><small>#{formatTime(start)}</small></small></div>")
        window.player.seekTo(ui.value)
      )

  langOneLangTwoStep = ->

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
    helloArray['Russian'] = 'привет'
    helloArray['Kazakh'] = 'Сәлем!'
    helloArray['Tajik'] = 'салом'
    helloArray['Uzbek'] = 'Salom'
    helloArray['Uyghur'] = 'Ässalamu läykum'
    helloArray['Albanian'] = 'Tung'

    if window.player.getOptions().indexOf('cc') > -1
      window.cc_status = "Which this video does!"
    else
      window.cc_status = "Unfortunately, this video doesn't have captions."

    $("#controls").html("
      <h3>One more question...</h3>
      <div style='margin: 30px;'>
        <label class='checkbox'>
          <input type='checkbox' id='lang1-and-lang2'>I want to write down the #{lang1} and #{lang2} side-by-side.
        <br>
        <div style='float: left; margin-left: 40px; margin-top: 25px;'><i>#{lang1}</i>: <br> <strong>#{helloArray[lang1]}</strong></div>
        <div style='float: left; margin-left: 40px; margin-top: 25px;'><i>#{lang2}</i>: <br> <strong>#{helloArray[lang2]}</strong></div>
        </label>
        <br>
      </div>
      <br>
      <div style='margin: 30px;'>
        <label class='checkbox'>
          <input type='checkbox' id='just-lang2'>I want to just write down the #{lang2} translation.
          <br>
          <div style='float: left; margin-left: 40px; margin-top: 25px;'><i>This is a good option if the YouTube <br>video already includes captions. <br><br> #{window.cc_status}</i></div>          
        </label>
        <br>
      </div>")

    $("#lang1-and-lang2").livequery ->
      $(this).click -> 
        window.translation_type = 'lang1_and_lang2'
        introText()

    $("#just-lang2").livequery -> 
      $(this).click ->
        window.translation_type = 'just_lang2'
        introText()

  inputLineLogic = -> 

    displayTooltip = ->

      if window.tool_helptip_displayed == false
        $('#lyrics-box').prepend("<strong><span id='tools-intro-text'>Hey, your very first translated line!<br>Nice job. Click on the line to edit or check your work.<br><br></span></strong>")
        delayedFade = ->
          $('#tools-intro-text').fadeOut()
        window.setTimeout(delayedFade, 8000)
        window.tool_helptip_displayed = true
        $('#intro-text').html('')

    if window.translation_type == 'lang1_and_lang2'

      $(".lang1-line").livequery ->
        $(this).keyup (e) ->
          entry = this.value
          console.log entry
          $('.lyrics-box.small').children().eq(0).html("<p class='white'>#{entry}</p>")
          e.preventDefault
          if e.which == 13 and ($('.lang2-line').val() isnt '')
            $('#lyrics-box').parent().slideDown()
            entry = this.value
            that_entry = $('.lang2-line').val()
            time = $("#current-loop-time").text()
            time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
            $.post('/new_line', { 'line' : { 'lang1' : "#{entry}", 'lang2' : "#{that_entry}", 'time' : "#{time_in_seconds}", 'duration' : "#{window.loop}", 'interpretation_id' : "#{interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
              console.log data.data
              line_id = data.data.id 
              duration = data.data.duration
              $('#lyrics-box').append("
                  <div class='line' id='lang1-#{time_in_seconds}' class='editing-lyrics' data-line-id=#{line_id} data-time=#{time_in_seconds} data-duration=#{window.loop}>
                    <div class='lyrics-container'>
                      <p><span class='edit-line-lang1'>#{that_entry}</span></p>
                    </div>
                    <div class='lyrics-container'>
                      <p><span class='edit-line-lang1'>#{entry}</span></p>
                    </div>
                  </div>
                  ")
              displayTooltip()
              $('#lyrics-box').scrollTo('100%')
              $('.lyrics-box.small').children().eq(0).html("")
              $('.lyrics-box.small').children().eq(1).html("")
              console.log data)
            $('#intro-text').fadeOut()
            $('.lang1-line').val('')
            $('.lang2-line').val('')
            window.section += 1
            $('.publish-button').html('<div class="btn btn-info" id="publish-button">Publish!</div>')
            $('.preview-button').html('<div class="btn btn-info" id="preview-button">Preview</div>').effect('highlight')

      $(".lang2-line").livequery ->
        $(this).keydown (e) ->
        $(this).keyup (e) ->
          entry = this.value
          console.log entry
          $('.lyrics-box.small').children().eq(1).html("<p class='white'>#{entry}</p>")
          if e.which == 13 and ($('.lang1-line').val() isnt '')
            $('#lyrics-box').parent().slideDown()
            entry = this.value
            that_entry = $('.lang1-line').val()
            time = $("#current-loop-time").text()
            time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
            $.post('/new_line', { 'line' : { 'lang1' : "#{that_entry}", 'lang2' : "#{entry}", 'time' : "#{time_in_seconds}", 'duration' : "#{window.loop}", 'interpretation_id' : "#{interp_id}" , 'upvotes' : 0, 'downvotes' : 0  } }, (data) ->
              console.log data.data
              line_id = data.data.id 
              duration = data.data.duration
              $('#lyrics-box').append("
                  <div class='line' id='lang1-#{time_in_seconds}' class='editing-lyrics' data-line-id=#{line_id} data-time=#{time_in_seconds} data-duration=#{window.loop}>
                    <div class='lyrics-container'>
                      <p><span class='edit-line-lang1'>#{that_entry}</span></p>
                    </div>
                    <div class='lyrics-container'>
                      <p><span class='edit-line-lang1'>#{entry}</span></p>
                    </div>
                  </div>
                  ")
              displayTooltip()
              $('.lyrics-box.small').children().eq(0).html("")
              $('.lyrics-box.small').children().eq(1).html("")
              $('#lyrics-box').scrollTo('100%')
              console.log data)
            window.section += 1
            if action_name isnt 'edit'
              $('.lang1-line').val('')
              $('.lang2-line').val('')
              $('.lang1-line').focus()
              $('.publish-button').html('<div class="btn btn-info" id="publish-button">Publish!</div>')
              $('.preview-button').html('<div class="btn btn-info" id="preview-button">Preview</div>').effect('highlight')

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
              $.post('/previous_line', { 'time' : "#{time_in_seconds}" }, (data) ->
                console.log data.data )
            window.section += 1
            $('.publish-button').html('<div class="btn btn-info" id="publish-button">Publish!</div>')
            $('.preview-button').html('<div class="btn btn-info" id="preview-button">Preview</div>')
            delayedShowSaved = ->
              $('.save-button').html('<div class="btn btn-info" id="save-button">Saved</div>')
            window.setTimeout(delayedShowSaved, 600)


  introText = ->
  
    if action_name isnt 'edit'
      window.player.pauseVideo()
  
    if action_name is 'new'
      $('#controls').html("<strong>
      Here we go!  Once you've filled in the translation, hit ENTER to submit each line. <br><br>
      If you need to look up a word, online dictionaries like <a href='http://www.wordreference.com/'>Wordreference</a> can be a great resource. <br><br>
      Don't worry if you have trouble understanding at first — you'll get tools to help you.<br><br>
      <a href='#' id='input-lines-go'>I'm ready!</a></strong>")

    $("#input-lines-go").livequery -> 
      $(this).click ->
        $('#controls').slideUp()
        inputLines()
        window.player.playVideo()

  inputLines = ->

    inputLineLogic()

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

# YOUTUBE PLAYER COMES IN HERE

  player = null
  window.rollover_pause = false

  tag = document.createElement("script")
  tag.src = "https://www.youtube.com/iframe_api"
  firstScriptTag = document.getElementsByTagName("script")[0]
  firstScriptTag.parentNode.insertBefore tag, firstScriptTag

  window.section = 0 
  window.time = 0
  window.got_volume = false

  window.onYouTubeIframeAPIReady = ->
    player = new YT.Player("new-video-box", {
      height: "315"
      width: "420"
      videoId: youtube_id
      playerVars: 
        {
        controls: 0
        cc_load_policy: 1
        }
      events:
        onReady: onPlayerReady
        onStateChange: onPlayerStateChange })
    console.log "Checking for cc..." + player.getOptions().indexOf('cc')
    window.player = player

  onPlayerReady = (event) ->
    event.target.playVideo()

  countVideoPlayTime = ->

    getTime = ->
      exact_time = player.getCurrentTime()
      window.time = Math.floor(exact_time)
      $(".timer-text").html(formatTime(window.time))
    setInterval(getTime, 100)

    current_loop_time = window.loop * window.section
    current_loop_end = window.loop * (window.section + 1)

    # DISPLAYING THE TIMING ABOVE THE TRANSLATION INPUT LINES 
    if window.loop isnt false
      $(".current-loop-time").html(formatTime(current_loop_time) + " to " + formatTime(current_loop_end))
    else
      $(".current-loop-time").html(formatTime(window.time))

    # LOOPING HAPPENS HERE
    if window.loop isnt false
      loopNow = ->
        loopingNow = ->
          player.seekTo(window.loop * window.section, true)
          player.setVolume(window.volume)
          player.pauseVideo()
          startUpAgain = ->
            player.playVideo()
            window.got_volume = false
          window.setTimeout(startUpAgain, 1200)
        window.setTimeout(loopingNow, 1000)
      fadeOut = ->
        if window.got_volume == false
          window.volume = player.getVolume()
          window.got_volume = true
          halfVolume = 0.5 * window.volume
          quarterVolume = 0.25 * window.volume
          tinyVolume = 0.1 * window.volume
          player.setVolume(halfVolume)
          softAndSlow = ->
            player.setVolume(quarterVolume)
          window.setTimeout(softAndSlow, 500)
      if window.time > (window.loop) * (window.section + .6)
        fadeOut()
        loopNow()

  counter = setInterval(countVideoPlayTime, 1000)
  done = false

  onPlayerStateChange = (event) ->
    if event.data == YT.PlayerState.PAUSED
      exact_time = player.getCurrentTime()
      window.time = Math.round(exact_time)
      window.section = window.time / window.loop

  delayedShow = -> 
    window.player.playVideo()
  window.setTimeout(delayedShow, 1000)
    
  # LOGIC FOR THE CONTROLS 

  $("#forward-loop").livequery ->
    $(this).click -> 
      window.section += 1
      player.seekTo(window.loop * window.section, true)

  $("#backward-loop").livequery ->
    $(this).click -> 
      window.section -= 1
      player.seekTo(window.loop * window.section, true)

  $('#loop-toggle').livequery -> 
    $(this).click ->
      $('#loop-status').html("Playing without loops.")
      $(this).attr('id','loop-status-off')
      $(this).html('<small>(on)</small>')
      $('#loop-slider').slideUp()
      window.loop = false
      console.log "Turning loops off."

  # LINE CONTROLS

  $('.watch-button').livequery ->
    $(this).click ->
      time = $(this).parent().parent().attr('data-time')
      window.player.seekTo(time)
      window.loop = $(this).parent().parent().attr('data-duration') 
      window.section = time / window.loop

  # REVISING LINE CONTENT 

  $('.line').livequery ->
    $(this).hover(
      -> $(this).attr('style','background-color: yellow;')
      -> $(this).attr('style','background-color: white;')
      )
    $(this).click ->
      if window.editing_line isnt 'on'
        id = $(this).attr('data-line-id')
        lang1 = $.trim($(this).children().eq(0).text())
        lang2 = $.trim($(this).children().eq(1).text())
        $(this).children().eq(0).children().eq(0).html("
          <div class='control-group'>
            <div class='controls'>
              <input type='text' class='input-xlarge' id='edit-line-lang1'>
            </div>
          </div>")
        $(this).children().eq(1).children().eq(0).html("
          <div class='control-group'>
            <div class='controls'>
              <input type='text' class='input-xlarge' id='edit-line-lang2'>
            </div>
          </div>")
        $('#edit-line-lang1').val(lang1)
        $('#edit-line-lang2').val(lang2)
        window.editing_line = 'on'
        $(this).prepend("
          <span style='float: left;'>
            <div class='btn btn-primary btn-small rounded tight-margins' id='add-line-above' data-line-id=#{id}> &uarr; add line </div>
            <div class='btn btn-primary btn-small rounded tight-margins' id='edit-timing' data-line-id=#{id}> adjust timing </div>
            <div class='btn btn-primary btn-small rounded tight-margins' id='delete-line' data-line-id=#{id}>delete line &darr;</div>
          </span>
          <br>")
        $(this).append("
          <br>
          <span style='float: right;'>
            <div class='btn btn-warning btn-small rounded btn-uniform-width tight-margins watch-button'>ask heyu</div>
            <div class='btn btn-warning btn-small rounded btn-uniform-width tight-margins share-button' href='https://twitter.com/share'>ask twitter</div>
          </span>")
        $(this).hover(
          -> $(this).attr('style','background-color: yellow;')
          -> $(this).attr('style','background-color: yellow;')
          )

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
        $('#add-delete').remove()
        window.editing_line = 'off'

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

  $('#delete-line').livequery ->
    $(this).click ->
      console.log "deleting line"
      window.editing_line = 'off'
      line_id = $(this).attr('data-line-id')
      $.post('/delete_line', { 'line' : { 'id' : "#{line_id}" } } )
      $(this).parent().parent().parent().slideUp()
      # The slideUp would be nice but unfortunately js from YouTube/Google interferes with a delayed remove() and mucks the whole thing
      $(this).parent().parent().parent().remove()

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

  # DIFFICULTY SETTINGS 

  $('#beginner').livequery ->
    $(this).click ->
      if $(this).prop('checked') == true
        $('#difficulty-settings').html('Difficulty: Beginner')
        $.post('/update_difficulty', { 'interp' : { 'id' : "#{interp_id}", 'difficulty' : "beginner" } })

  $('#intermediate').livequery ->
    $(this).click ->
      if $(this).prop('checked') == true
        $('#difficulty-settings').html('Difficulty: Intermediate')
        $.post('/update_difficulty', { 'interp' : { 'id' : "#{interp_id}", 'difficulty' : "intermediate" } })

  $('#advanced').livequery ->
    $(this).click ->
      if $(this).prop('checked') == true
        $('#difficulty-settings').html('Difficulty: Advanced')
        $.post('/update_difficulty', { 'interp' : { 'id' : "#{interp_id}", 'difficulty' : "advanced" } })

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

  $("#publish-button").livequery ->
    $(this).click ->
      if $("#user-id").attr('data-user') != "logged-out"
        $.post('/publish', { 'interpretation' : { 'id' : "#{interp_id}" } }, (data) ->
          console.log data.data )
        window.location.href = "/interpretations/#{interp_id}"
      else
        $('.preview-button').hide()
        $('.publish-button').html("<p><a href='/sign_up?interp=#{interp_id}'><strong>Sign up for Heyu?</strong></a> That way your username will appear alongside your translation. Get props for excellent work!<br><br>If you've already signed up, be sure to <a href='/sign_in?interp=#{interp_id}'><strong>sign in</strong></a>.<br><br>Otherwise, <a href='/interpretations/#{interp_id}'>submit your translation anonymously.</a>")

  $("#preview-button").livequery ->
    $(this).click ->
      window.location.href = "/interpretations/#{interp_id}"

# YOUTUBE WINDOW STICKY ON SCROLL

  $window = $(window)
  video_box = $('#outer-video-box')
  video_top = video_box.offset().top
  lyrics_container = $('.lyrics-container')
  $window.scroll ->
    video_box.toggleClass('sticky', $window.scrollTop() > video_top)
    lyrics_container.toggleClass('sticky', $window.scrollTop() > video_top)