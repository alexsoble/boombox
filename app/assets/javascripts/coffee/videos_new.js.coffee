$ ->

  youtube_id = $('#data').attr('data-youtube-id')
  lang1 = $('#data').attr('data-lang-one')
  lang2 = $('#data').attr('data-lang-two')
  window.lang1 = lang1
  window.lang2 = lang2
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
  window.valuesChanging = false
  window.quiz_making_mode = false
  window.quiz_words = []
  window.tool_helptip_displayed = false
  window.editing_line = 'off'
  window.editing_line_timing = 'off'
  window.editing_line_ask_heyu = 'off'
  window.choruslang2 = ''
  window.loop_range_appended = false
  $('#timer-box').html('<div id="timer">
    <h2 class="timer-text" id="big-timer"></h2>
    </div>')
  $('#lyrics').hide()

  if action_name is 'edit'
    $('.tools-container').toggle('width')
    if published is 'false'
      $('.preview-button').html('<div class="btn btn-info" id="preview-button">Preview</div>')
    if published is 'true'
      $('.publish-button').html('<div class="btn btn-info" id="publish-button">Update</div>')
  if action_name isnt 'edit'
    $('#title-box').hide()
    $('#title-box').slideDown('5000')
    $('#timer-box').hide()
    $('#settings').hide()
    $("#controls").append('<br><div class="btn-group relative" id="settings-and-start">
        <br><br><br><br>
        <a class="btn btn-info btn-large center-pill rounded" id="start" style="position: absolute; left: 108px;">Start translating</a>
      </div>')
    $("#controls").fadeIn('slow')

  $("#start").livequery ->
    $(this).click -> 
      $('#settings').slideDown()
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

  $("#yes-loops").livequery ->
    $(this).click -> 
      window.section = window.time / 4
      window.loop = 4
      $(this).parent().parent().fadeOut()
      sliderSetup()
      playbackControls(window.video_duration)
      loopingBehavior()
      langOneLangTwoStep()

  $("#no-loops").livequery ->
    $(this).click -> 
      $(this).parent().parent().fadeOut()
      sliderSetup()
      playbackControls(window.video_duration)
      straightPlaybackBehavior()
      langOneLangTwoStep()

  sliderSetup = ->

    $('#settings').append("
      <div id='playback-buttons' style='float: right; margin-right: 20px; margin-top: 20px; margin-bottom: 5px;'>
        <div class='btn btn-info btn-small rounded tight-pack' id='backward'> &larr; </div>
        <div class='btn btn-info btn-small rounded tight-pack' id='play-pause'> pause </div> 
        <div class='btn btn-info btn-small rounded tight-pack' id='forward'> &rarr; </div>
        <div class='btn btn-info btn-small rounded tight-pack' id='volume'> <i class='icon-volume-up'></i> </div>
        <div class='btn btn-info btn-small rounded tight-pack' id='helpz'> ? </div>
      </div>")

    if window.loop != false
      loop_toggle_initalize = "turn off loops"
      loop_toggle_initalize_style = "float: right;"
      $('#settings').addClass('looping')
    else
      loop_toggle_initalize = "turn on loops"
      loop_toggle_initalize_style = "float: left;"

    $('#settings').append("
      <div style='float: left; margin-left: 20px; margin-top: 20px; width: 140px;'>
        <div class='loop-toggle'>
          <div class='btn btn-primary btn-small rounded tight-pack' id='loop-on' style='#{loop_toggle_initalize_style}'> #{loop_toggle_initalize} </div>
        </div>
        <div class='quiz-toggle'>
          <div class='btn btn-info btn-small rounded tight-pack' id='quiz-on'> make it a quiz </div>
        </div>
      </div>")

    $('#settings').append("
      <div id='loop-settings'>
        <div class='playback-left-label end-label'><div class='playback-left-label inner-label'></div></div>
          <div id='playback-slider'></div>
        <div class='playback-right-label end-label'><div class='playback-right-label inner-label'></div></div>
        <div id=loop-status'></div>
      </div>")

    $('#loop-settings').after("
      <!---<div style='margin-left: 20px;'>
        <div class='btn btn-info btn-small rounded' style='position: absolute; left: 20px bottom: 400px;'> Teacher tools </div>
         <span id='set-difficulty'><a>Video difficulty</a></span>
        <div class='controls'>
          <select id='difficulty-settings'>
            <option value='beginner' class='difficulty-setting'>Beginner</option>
            <option value='intermediate' class='difficulty-setting'>Intermediate</option>
            <option value='advanced' class='difficulty-setting'>Advanced</option>
          </select> -->
      </div>")

  playbackControls = (video_duration) ->

    $('.playback-left-label.inner-label').html(":00")
    $('.playback-right-label.inner-label').html("#{shortFormatTime(video_duration)}")

  loopingBehavior = ->

    if $('#playback-slider').hasClass('ui-slider')
      $('#playback-slider').slider('destroy')

    $('#playback-slider').rangeSlider(
      arrows: false
      step: 1
      defaultValues:
        min: window.time
        max: window.time + 4
      bounds:
        min: 0
        max: video_duration
      range:
        min: 0
        max: 12
      formatter: (val) -> 
        shortFormatTime(val))

    $('#playback-slider').children().eq(3).addClass('loop-handle-label')
    $('#playback-slider').children().eq(4).addClass('loop-handle-label')

    if window.loop_range_appended == false
      $('.ui-rangeSlider-bar').append('<div id="loop-bar"></div>')
      window.loop_range_appended = true

    $('.loop-handle-label.ui-rangeSlider-rightLabel').show()
    $('.loop-handle-label.ui-rangeSlider-leftLabel').html("<div class='inner-label'>#{shortFormatTime($('#playback-slider').rangeSlider("values").min)}</div>")
    $('.loop-handle-label.ui-rangeSlider-rightLabel').html("<div class='inner-label'>#{shortFormatTime($('#playback-slider').rangeSlider("values").max)}</div>")
    
    $('#playback-slider').off("valuesChanging").off("userValuesChanged")
    $('#playback-slider').on("valuesChanging", (e, data) ->
      start = data.values.min
      end = data.values.max
      player.seekTo(start)
      window.loop = end - start
      window.section = start / window.loop
      $('.ui-rangeSlider-leftLabel.loop-handle-label').html("<div class='text-padding'>#{shortFormatTime(start)}</div>")
      $('.loop-handle-label.ui-rangeSlider-rightLabel').html("<div class='text-padding'>#{shortFormatTime(end)}</div>")
    )

  straightPlaybackBehavior = ->

    if $('#playback-slider').hasClass('ui-rangeSlider')
      $('#playback-slider').rangeSlider('destroy')

    $('#playback-slider').slider(
      min: 0,
      max: window.video_duration,
      value: window.time,
      step: 1
      slide: (event, ui) ->
        player.seekTo($('#playback-slider').slider("value"))
    )

  longVideoControls = ->

    left_boundary = Math.floor(window.time / 45) * 45
    right_boundary = left_boundary + 60

    $('#loop-slider').rangeSlider(
      step: 1
      bounds:
        min: left_boundary
        max: right_boundary
      defaultValues:
        min: window.time
        max: window.time + 4
      range:
        min: 1
        max: 12
      formatter: (val) -> 
        shortFormatTime(val)
      )

    # CHANGES TO THE PLAYBACK SLIDER (ORDER OF OPERATIONS MATTERS HERE v !!!)

    $('.end-label.playback-left-label').addClass('disabled')
    $('.end-label.playback-right-label').addClass('disabled')

    $('#playback-slider').off("valuesChanging").off("userValuesChanged")
    $('#playback-slider').rangeSlider("values", left_boundary, right_boundary)

    $('#playback-slider').children().eq(3).addClass('end-label').addClass('loop-range-label').html("#{shortFormatTime(left_boundary)}")
    $('#playback-slider').children().eq(4).addClass('end-label').addClass('loop-range-label').html("#{shortFormatTime(right_boundary)}")
    $('#playback-slider').children().eq(0).children().eq(1).attr('style','background-color: #0F82F5;')

    # BEHAVIOR FOR THE PLAYBACK SLIDER

    $('#playback-slider').on("valuesChanging", (e, data) ->
      start = data.values.min
      end = data.values.max
      player.seekTo(start)
      $('.end-label.loop-range-label.ui-rangeSlider-leftLabel').html("#{shortFormatTime(start)}")
      $('.end-label.loop-range-label.ui-rangeSlider-rightLabel').html("#{shortFormatTime(end)}")
      $('.inner-label.looping-left-label').html("#{shortFormatTime(start)}")
      $('.inner-label.looping-right-label').html("#{shortFormatTime(end)}")
    )

    $('#playback-slider').on("userValuesChanged", (e, data) ->
      start = data.values.min
      end = data.values.max

      $('#loop-slider').rangeSlider(
        bounds:
          min: start
          max: end
        )
      $('#loop-slider').rangeSlider("values", start, start + window.loop)
      $('.loop-handle-label.ui-rangeSlider-leftLabel').html("#{shortFormatTime(start)}")
      $('.loop-handle-label.ui-rangeSlider-rightLabel').html("#{shortFormatTime(start + window.loop)}")
    )

  # BEHAVIOR FOR THE LOOP SLIDER: SHIFT LEFT / SHIFT RIGHT CONTROLS

    $('#loop-slider').on("userValuesChanged", (e, data) ->
      bounds = $('#loop-slider').rangeSlider("bounds")
      min = bounds.min
      max = bounds.max
      start = data.values.min
      end = data.values.max

      shiftRight = -> 
        console.log "shiftRight"
        video_duration = window.player.getDuration()
        if end == max and max < video_duration
          if max + 30 < video_duration
            $('.inner-label.looping-left-label').text(shortFormatTime(min + 30))
            $('.inner-label.looping-right-label').text(shortFormatTime(max + 30))
            $('#loop-slider').rangeSlider(
              bounds:
                min: min + 30
                max: max + 30
            ).rangeSlider("values", start, end)
            $('#playback-slider').rangeSlider("values", min + 30, max + 30)
            $('.ui-rangeSlider-leftLabel.loop-range-label').html("#{shortFormatTime(min + 30)}")
            $('.ui-rangeSlider-rightLabel.loop-range-label').html("#{shortFormatTime(max + 30)}")
          else
            $('.inner-label.looping-left-label').text(shortFormatTime(video_duration - 60))
            $('.inner-label.looping-right-label').text(shortFormatTime(video_duration))
            $('#loop-slider').rangeSlider(
              bounds:
                min: video_duration - 60
                max: video_duration
            ).rangeSlider("values", video_duration - 59, video_duration - 55)

      shiftLeft = -> 
        console.log "shiftLeft"
        if start == min and min > 0
          if min > 30
            $('.inner-label.looping-left-label').text(shortFormatTime(min - 30))
            $('.inner-label.looping-right-label').text(shortFormatTime(max - 30))
            $('#loop-slider').rangeSlider(
              bounds:
                min: min - 30
                max: max - 30
            ).rangeSlider("values", start, end)
            $('#playback-slider').rangeSlider("values", min - 30, max - 30)
            $('.ui-rangeSlider-leftLabel.loop-range-label').html("#{shortFormatTime(min - 30)}")
            $('.ui-rangeSlider-rightLabel.loop-range-label').html("#{shortFormatTime(max - 30)}")
          else
            $('.inner-label.looping-left-label').text(shortFormatTime(0))
            $('.inner-label.looping-right-label').text(shortFormatTime(60))
            $('#loop-slider').rangeSlider(
              bounds:
                min: 0
                max: 60
            ).rangeSlider("values", 55, 59)           

      waitForIt = (direction) -> 
        direction()
      if end == max
        window.setTimeout(waitForIt(shiftRight), 1000)
      if start == min
        window.setTimeout(waitForIt(shiftLeft), 1000)
      )

  langOneLangTwoStep = ->

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
        <div style='float: left; margin-left: 40px; margin-top: 25px;'><i>#{lang1}</i>: <br> <strong>#{window.helloArray[lang1]}</strong></div>
        <div style='float: left; margin-left: 40px; margin-top: 25px;'><i>#{lang2}</i>: <br> <strong>#{window.helloArray[lang2]}</strong></div>
        </label>
        <br>
      </div>
      <br>
      <div style='margin: 30px;'>
        <label class='checkbox'>
          <input type='checkbox' id='just-lang2'>I want to just write down the #{lang2} translation.
          <br>
          <div style='float: left; margin-left: 40px; margin-top: 25px;'>This is a good option if the YouTube <br>video already includes captions. <br><br> #{window.cc_status}</div>          
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
        $('#lang1-input').parent().remove()
        $('#lyrics-box').attr('style','width: 300px;')
        introText()

  if action_name is 'edit'
    window.translation_type = translation_type
    sliderSetup()

  inputLineLogic = -> 

    displayTooltip = ->

      if window.tool_helptip_displayed == false and action_name == 'new'
        $('#lyrics-box').prepend("<span id='tools-intro-text'><strong>Hey, your very first translated line!</strong><br>Click on the line to edit or check your work.<br><br></span>")
        delayedFade = ->
          $('#tools-intro-text').fadeOut()
        window.setTimeout(delayedFade, 8000)
        window.tool_helptip_displayed = true
        $('#intro-text').html('')

    addNewLineInRightPlace = (lang1, lang2) ->
      lines = []
      $('.line').each(->
        time = $(this).attr('data-time')
        if window.loop != false 
          if window.loop * window.section > time
            lines.push time
        else
          if window.time > time
            lines.push time
        )

      if lines.length > 0
        the_right_time = Math.max.apply(Math, lines)
        console.log the_right_time
        correct_line = $(".line[data-time=#{the_right_time}]").eq(0)
      else
        $('#lyrics-box').prepend("<div id='start-lyrics'></div>")
        correct_line = $("#start-lyrics")

      if window.loop != false then duration = window.loop else duration = 4

      if window.translation_type == 'lang1_and_lang2'
        correct_line.after("
            <div class='line' data-time=#{window.time} data-duration=#{duration}>
              <div class='lyrics-container'>
                <p>#{lang1}</p>
              </div>
              <div class='lyrics-container'>
                <p>#{lang2}</p>
              </div>
            </div>")
      if window.translation_type == 'just_lang2'
        correct_line.after("
            <div class='line' data-time=#{window.time} data-duration=#{duration}>
              <div class='lyrics-container'>
                <p>#{lang2}</p>
              </div>
            </div>")

      correct_line.next().effect("highlight", {}, 2000)
      resetForNextLine()

    moveLoopForward = -> 
      $('#loop-slider').rangeSlider("values", window.section * window.loop, (window.section + 1) * window.loop)
      $('.ui-rangeSlider-leftLabel.loop-handle-label').children(':first').html("<div class='text-padding'>#{shortFormatTime(window.time)}</div>")
      $('.ui-rangeSlider-rightLabel.loop-handle-label').children(':first').html("<div class='text-padding'>#{shortFormatTime(window.time + window.loop)}</div>")
      window.player.seekTo(window.section * window.loop)

      if window.loop != false
        number_of_loops = $('.line').length
        console.log "number_of_loops: " + number_of_loops
        total_seconds = 0
        $('.line').each(->
          total_seconds += parseInt($(this).attr('data-duration'))
        )
        console.log "total_seconds: " + total_seconds
        fraction = total_seconds / window.video_duration
        percentage = (Math.round(fraction * 10000))/100 + '%'
        if .4 > fraction then status = "Solid start!"
        if .7 >= fraction >= .4 then status = "You got this!"
        if fraction > .7 then status = "Nearly there!"
        $('#loop-status').html("You've translated #{number_of_loops} loops, totalling #{total_seconds} out of #{total_seconds}, or approximately #{percentage} of the video. #{status}")

    resetForNextLine = -> 
      $('.preview-button').html('<div class="btn btn-info" id="preview-button">Preview</div>').effect('highlight')
      $('.lyrics-box.small').children().eq(0).html("")
      $('.lyrics-box.small').children().eq(1).html("")
      $('#lyrics-box').scrollTo('100%')
      $('#intro-text').fadeOut()
      $('.lang1-line').val('')
      $('.lang2-line').val('')
      $('.lang1-line').focus()
      window.section += 1
      displayTooltip()
      moveLoopForward()

    if window.translation_type == 'lang1_and_lang2'

      $(".lang1-line").livequery ->
        $(this).keyup (e) ->
          entry = this.value
          $('.lyrics-box.small').children().eq(0).html("<p class='white'>#{entry}</p>")
          if e.which == 13 and ($('.lang2-line').val() isnt '')
            $('#lyrics-box').parent().slideDown()
            entry = this.value
            that_entry = $('.lang2-line').val()
            addNewLineInRightPlace(entry, that_entry)

      $(".lang2-line").livequery ->
        $(this).keyup (e) ->
          entry = this.value
          $('.lyrics-box.small').children().eq(1).html("<p class='white'>#{entry}</p>")
          if e.which == 13 and ($('.lang1-line').val() isnt '')
            $('#lyrics-box').parent().slideDown()
            entry = this.value
            that_entry = $('.lang1-line').val()
            addNewLineInRightPlace(that_entry, entry)

    if window.translation_type == 'just_lang2'

      $(".lang2-line").livequery ->
        $(this).keyup (e) ->
          if e.which == 13
            entry = this.value
            addNewLineInRightPlace('', entry)

  introText = ->
  
    if action_name isnt 'edit'
      window.player.pauseVideo()
  
    if action_name is 'new'
      $('#controls').html("
        <strong>Here we go!</strong><br><br>  
        Your goal: translate the video <strong>line-by-line.</strong><br><br> Once you've translated a line, hit <strong>ENTER</strong> to move to the next line. <br><br>
        Be sure to <strong><a href='/sign_up?interp=#{interp_id}'>sign up for a Heyu account</strong></a> if you'd like to save or publish your translation.<br><br>
        <h3><a href='#' id='input-lines-go'><strong>I'm ready!</strong></a></h3>")

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

      # ADJUSTING INPUT LINES FOR R-T-L VERSUS L-T-R

      if rtlArray.indexOf(window.lang1) > -1
        $('.lang1-line').attr('style','direction: rtl;') 

      if rtlArray.indexOf(window.lang2) > -1
        $('.lang2-line').attr('style','direction: rtl;') 

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
      
      if rtlArray.indexOf(window.lang2) > -1
        $('.lang2-line').attr('style','direction: rtl;') 

  if action_name == 'edit'
    inputLineLogic()

# YOUTUBE PLAYER COMES IN HERE

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
    video_duration = window.player.getDuration()
    window.video_duration = video_duration
    playbackControls(video_duration)
    if window.loop == false
      straightPlaybackBehavior()
    else
      loopingBehavior()
    event.target.playVideo()

    # CONTROLS FOR LONG VIDEOS COME IN HERE    
    if video_duration > 300
      longVideoControls()

  countVideoPlayTime = ->

    exact_time = player.getCurrentTime()
    window.time = Math.floor(exact_time)
    $(".timer-text").html(formatTime(window.time))

    current_loop_time = window.loop * window.section
    current_loop_end = window.loop * (window.section + 1)

    # PLAYBACK SLIDER MOVES HERE
    if window.loop is false and window.valuesChanging is false
      $('#playback-slider').slider("value", window.time)

    # LOOP BAR INCHES FORWARD HERE
    if window.loop isnt false
      $('#loop-bar').animate(
        { width: "#{((window.time - current_loop_time)/(window.loop)) * 330 * (window.loop / 60)}px" }, 
      )

    # DISPLAYING THE TIMING ABOVE THE TRANSLATION INPUT LINES 
    if window.loop isnt false
      $(".current-loop-time").html(formatTime(current_loop_time) + " to " + formatTime(current_loop_end))
    else
      $(".current-loop-time").html(formatTime(window.time))

    # LOOPING HAPPENS HERE
    if window.loop isnt false
      loopNow = ->
        loopingNow = ->
          $('#loop-bar').animate({width: 'toggle'})
          player.seekTo(window.loop * window.section, true)
          player.setVolume(window.volume)
          player.pauseVideo()
          startUpAgain = ->
            player.playVideo()
            # $('#loop-bar').animate({width: "#{330 * (window.loop / 60)}px"}, duration: "#{window.loop * 1000}")
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
      modifier = .69 + (window.loop * 0.015)
      if window.time > (window.loop) * (window.section + modifier)
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

  $("#forward").livequery ->
    $(this).click -> 
      console.log "forward"
      if window.loop != false
        window.section += 1
        window.player.seekTo(window.loop * window.section, true)
        $('#loop-slider').rangeSlider("values", window.loop * window.section, window.loop * (window.section + 1))
        $('.ui-rangeSlider-leftLabel.loop-handle-label').children(':first').html("<div class='text-padding'>#{shortFormatTime(window.loop * window.section)}</div>")
        $('.ui-rangeSlider-rightLabel.loop-handle-label').children(':first').html("<div class='text-padding'>#{shortFormatTime(window.loop * (window.section + 1))}</div>")
      else
        player.seekTo(window.time + 15)

  $("#backward").livequery ->
    $(this).click -> 
      console.log "backward"
      if window.loop != false
        window.section -= 1
        window.player.seekTo((window.section - 1) * window.loop, true)
        $('#loop-slider').rangeSlider("values", window.loop * (window.section - 1), window.loop * window.section)
        $('.ui-rangeSlider-leftLabel.loop-handle-label').html("<div class='text-padding'>#{shortFormatTime(window.loop * (window.section - 1))}</div>")
        $('.ui-rangeSlider-rightLabel.loop-handle-label').html("<div class='text-padding'>#{shortFormatTime(window.loop * window.section)}</div>")
      else
        if window.time > 14
          player.seekTo(window.time - 15)
        else
          player.seekTo(0)

  $('#play-pause').livequery ->
    $(this).click ->
      console.log "play/pause"
      state = window.player.getPlayerState()
      if state == 1
        player.pauseVideo()
        $(this).html('play')
      if state == 2
        player.playVideo()
        $(this).html('pause')

  # REVISING LINE CONTENT 

  $('.line').livequery ->
    $(this).hover(
      -> if window.quiz_making_mode == false then $(this).attr('style','background-color: yellow;')
      -> $(this).attr('style','background-color: white;')
      )
    $(this).click ->
      if window.editing_line isnt 'on' and window.quiz_making_mode == false
        window.editing_line = 'on'
        id = $(this).attr('data-line-id')
        $(this).attr('class','line edited-line rounded')
        lang1 = $.trim($(this).children().eq(0).text())
        lang2 = $.trim($(this).children().eq(1).text())
        $(this).html("
        <div class='lines-being-edited'>
          <div class='control-group' style='float: left;'>
            <div class='controls'>
              <input type='text' class='input-xlarge edit-line' id='edit-line-lang1'>
            </div>
          </div>
          <div class='control-group' style='float: right;'>
            <div class='controls'>
              <input type='text' class='input-xlarge edit-line' id='edit-line-lang2'>
            </div>
          </div>
        </div>")
        $('#edit-line-lang1').val(lang1)
        $('#edit-line-lang2').val(lang2)
        $(this).prepend("
          <span style='float: left; margin: 10px;' class='toolbox-upper'>
            <div class='btn btn-small btn-primary rounded tight-margins' id='done-editing' style='background-color: white; border: solid 1px; border-color: black; color: black;'> done editing </div>
            <div class='btn btn-inverse btn-small rounded tight-margins' id='delete-line' data-line-id=#{id}> delete line </div>
          </span>
          <span style='float: right; margin: 10px;' class='toolbox-upper'>
            <div class='btn btn-success btn-small rounded tight-margins' id='ask-twitter' data-twitter-url='https://twitter.com/share?text=Speak #{window.lang1}? What do you think about this translation? http://localhost:3000/interpretations/#{interp_id}'> get help from twitter </div>
            <div class='btn btn-success btn-small rounded tight-margins' id='ask-heyu'> get help from heyu </div>
          </span>
          </span>
          <br>")
        $(this).append("
          <br>
          <span style='float: right; margin: 10px;' class='toolbox-lower'>
            <div class='btn btn-primary btn-small rounded tight-margins' id='mark-chorus'> &uarr; set as chorus </div>
            <div class='btn btn-primary btn-small rounded tight-margins' id='add-chorus'> add chorus &darr; </div>
          </span>
          <span style='float: left; margin: 10px;' class='toolbox-lower'>
            <div class='btn btn-small btn-warning rounded tight-margins' id='edit-timing' data-line-id=#{id}> adjust timing </div>
          </span>")
        $('#lyrics-box').scrollTo($('.edited-line'))
        $(this).hover(
          -> $(this).attr('style','background-color: #F9F9F9;')
          -> $(this).attr('style','background-color: #F9F9F9;')
          )

  $('#mark-chorus').livequery ->
    $(this).click -> 
      window.choruslang1 = $('#edit-line-lang1').val()
      window.choruslang2 = $('#edit-line-lang2').val()
      doneEditing()

  $('#add-chorus').livequery ->
    $(this).click -> 
      if window.choruslang2 isnt ''
        new_time = parseInt($(this).parent().parent().attr('data-time')) - 4
        $('.edited-line').after("
          <div class='line' data-time=#{new_time} data-duration=4>
            <div class='lyrics-container'>
              <p>#{window.choruslang1}</p>
            </div>
            <div class='lyrics-container'>
              <p>#{window.choruslang2}</p>
            </div>
          </div>")
        doneEditing()

  # QUIZ WORDS GET ADDED HERE v

  $('p').livequery ->
    $(this).hover -> 
      if window.quiz_making_mode == true and $(this).attr('class') != 'lettered'
        $(this).lettering('words')
        $(this).addClass('lettered')

  $('[class^="word"]').livequery ->
    $(this).click ->
      this_word = $(this)
      if this_word.hasClass('blue')
        this_word.removeClass('blue')
        index = window.quiz_words.indexOf(this_word.html())
        window.quiz_words.splice(index, 1)
      else
        this_word.addClass('blue')
        window.quiz_words.push this_word.html()
        console.log JSON.stringify(window.quiz_words)

  $('#delete-line').livequery ->
    $(this).click ->
      console.log "deleting line"
      window.editing_line = 'off'
      line_id = $(this).attr('data-line-id')
      $(this).parent().parent().slideUp()
      # ^The slideUp would be nice but unfortunately js from YouTube/Google interferes with a delayed remove() and mucks up the whole thing
      $(this).parent().parent().remove()

  $('.edit-line').livequery ->
    $(this).keyup (e) ->
      e.preventDefault
      if e.which == 13 and this.value isnt ''
        doneEditing()

  $('#ask-twitter').livequery ->
    $(this).click ->
      start_time = parseInt($(this).parent().parent().attr('data-time'))
      duration = parseInt($(this).parent().parent().attr('data-duration'))
      url = $(this).attr('data-twitter-url') + '?clip=yes&start=' + start_time + '&duration=' + duration
      window.open(url,'name','width=200,height=200')

  $('#ask-heyu').livequery ->
    $(this).click ->
      if window.editing_line_ask_heyu isnt 'on'
        $(this).parent().parent().after("
          <span id='coming-soon' style='float: left; background-color: orange; width: 500px;'>
            <span style='margin: 10px;'>
              <strong>Coming soon</strong>: compare your translation with other Heyu users'.
            </span>
          </span>
          ")
        window.editing_line_ask_heyu = 'on'

  doneEditing = ->
    window.editing_line = 'off'
    window.editing_line_timing = 'off'
    window.editing_line_ask_heyu = 'off'
    line_id = $('.edited-line').attr('data-line-id')
    time = $('.edited-line').attr('data-time')
    duration = $('.edited-line').attr('data-duration')
    lang1 = $('#edit-line-lang1').val()
    lang2 = $('#edit-line-lang2').val()
    $('.edited-line').before("
      <div class='line' data-line-id=#{line_id} data-time=#{time} data-duration=#{duration}>
        <div class='lyrics-container'>
          <p>#{lang1}</p>
        </div>
        <div class='lyrics-container'>
          <p>#{lang2}</p>
        </div>
      </div>")
    $('.edited-line').prev().effect("highlight", {}, 2000)
    $('.edited-line').remove()
    $('#coming-soon').remove()
    $('#loop-settings').slideDown()

  $('#done-editing').livequery ->
    $(this).click ->
      doneEditing()

  $('#done-editing-time').livequery ->
    $(this).click ->
      doneEditing()

  $('#edit-timing').livequery ->
    $(this).click ->
      if window.editing_line_timing isnt 'on'
        window.editing_line_timing = 'on'

        original_start_time = parseInt($(this).parent().parent().attr('data-time'))
        console.log "original_start_time: " + original_start_time
        original_end_time = original_start_time + parseInt($(this).parent().parent().attr('data-duration'))
        console.log "original_end_time: " + original_end_time
        original_midpoint = Math.round((original_start_time + original_end_time) / 2)

        player.seekTo(original_start_time)
        window.loop = original_end_time - original_start_time
        window.section = original_start_time / window.loop

        $(this).replaceWith("<div class='btn btn-small btn-primary rounded tight-margins' id='done-editing-time' style='background-color: white; border: solid 1px; border-color: orange; color: orange;'> done adjusting timing</div>")

        $('#done-editing-time').parent().parent().append("
            <br>
            <div id='edit-timing-slider'></div>
            ")
        $('#edit-timing-slider').rangeSlider(
          arrows: false
          step: 1
          defaultValues:
            min: original_start_time
            max: original_end_time
          if original_start_time > 5
            bounds:
              min: original_start_time - 5
              max: original_end_time + 5
          else
            bounds:
              min: 0
              max: original_end_time + 5
          range:
            min: 1
            max: 12
          formatter: (val) -> 
            shortFormatTime(val)
          ).bind("valuesChanged", (e, data) ->
            start = data.values.min
            $(this).parent().attr('data-time',start)
            end = data.values.max
            $(this).parent().attr('data-duration', end - start)
            player.seekTo(start)
            window.loop = end - start
            window.section = start / window.loop
          ).bind("valuesChanging", (e, data) ->
            $('#loop-settings').slideUp()
          )
          $('#lyrics-box').scrollTo('.edited-line')

  # LOOP TOGGLE AND DIFFICULTY SETTINGS 

  $('.loop-toggle').livequery -> 
    $(this).click -> 
      if window.loop == false
        window.loop = 4
        window.section = window.time / window.loop
        loopingBehavior()
        $('#loop-on').html('turn off loops')
        $('#loop-on').attr('style','float: right;')

      else
        window.loop = false
        straightPlaybackBehavior()
        $('#loop-on').html('turn on loops')
        $('#loop-on').attr('style','float: left;')

  $('.quiz-toggle').livequery -> 
    $(this).click -> 
      if window.quiz_making_mode == false
        window.quiz_making_mode = true
        player.pauseVideo()
        $('#quiz-on').attr('style','float: right;')
        $('.loop-toggle').parent().attr('style','float: right; margin-right: 20px; margin-top: 20px;')
        $('#quiz-on').html('quiz-making on')
        $('#loop-settings').before('<div id="quiz-settings"></div>')

        # ADD THE QUIZ CONTROLS HERE
        $('#quiz-settings').append("
          <div style='float: left; width: 160px;'>
            <br>
            Quiz name:<br> <input type='text' id='quiz-name' style='width: 200px;'><br>
            Description:<br> <input type='text' id='quiz-description' style='width: 200px;'><br>
          </div>
          <div style='float: left;'>
            <input type='checkbox' id='grammar'> Grammar quiz (example: \"click all past-tense verbs\")<br>
            <input type='checkbox' id='vocabulary'> Vocabulary quiz (fill-in-the-blank style)
          </div>
          <div class='btn btn-info rounded' id='quiz-done-button' style='float: right;'>Create quiz</div> 
        ")

        # GET RID OF LOOP RELATED STUFF HERE 
        $('.loop-toggle').slideUp()
        $('#loop-settings').slideUp()
        $('#new-video-box').slideUp()
        $('#timer').slideUp()
        $('#settings').addClass('quiz-mode')
        $('#playback-buttons').slideUp()
        quizSetup()

        # GRAMMAR AND VOCAB CHECKBOX BEHAVIOR HERE

        $('#grammar').livequery ->
          $(this).click -> 
            $('#vocabulary').prop('checked', false)

        $('#vocabulary').livequery ->
          $(this).click -> 
            $('#grammar').prop('checked', false)

      else
        window.quiz_making_mode = false
        $('.loop-toggle').slideDown()
        $('#quiz-on').attr('style','float: left;')
        $('#quiz-on').html('make it a quiz')
        $('#quiz-settings').remove()

        # PUT BACK LOOP RELATED STUFF HERE 
        $('#loop-settings').slideDown()
        $('#new-video-box').slideDown()
        $('#settings').removeClass('quiz-mode')
        $('#timer').slideDown()
        $('#playback-buttons').slideDown()

  $('#difficulty-settings').hide()

  $('#set-difficulty').livequery ->
    $(this).click ->
      $('#set-difficulty').toggle()
      $('#difficulty-settings').toggle()

  $('#difficulty-settings').livequery ->
    $(this).click ->
      console.log "clicked!!"
      $('#difficulty-settings').toggle()
      $('#set-difficulty').toggle()
      $.post('/update_difficulty', { 'interp' : { 'id' : "#{interp_id}", 'difficulty' : "#{$(this).attr('value')}" } })

  # QUIZ SETUP

  quizSetup = -> 
    $('#quiz-done-button').livequery ->
      $(this).click -> 
        $.post('/new_quiz', { 'quiz' : { 'interpretation_id' : "#{interp_id}", 'quiz_type' : "#{$("input:checked").attr('id')}", 'name' : "#{$('#quiz-name').val()}", 'description' : "#{$('#quiz-description').val()}"} }, (data) ->
          console.log data.data
          quiz_id = data.data.id 
        
          words_to_save = []
          window.quiz_words.forEach (element, index) ->
            word = (text : element, quiz_id : quiz_id )
            words_to_save.push word

          $.post('/save_quiz_words', { 'quiz_id' : "#{quiz_id}", 'words' : "#{JSON.stringify(words_to_save)}" }, (data) ->
            console.log data
            window.location.href = "/quizzes/#{quiz_id}" )
        )

  # OLD STUFF...  MAYBE NOT USELESS THOUGH? 

  $("#timer-toggle").livequery ->
    $(this).click ->
      $("#timer-box").toggle()

# PREVIEW/SAVE BUTTONS

  save = ->
    lines = []
    $('.line').each(->
      if $(this).attr('class') == 'line'
        this_lang1 = $.trim($(this).children().eq(0).text())
        line = (time : $(this).attr('data-time'), duration : $(this).attr('data-duration'), lang1 : this_lang1, lang2 : $.trim($(this).children().eq(1).text()), interpretation_id : interp_id )
      else
        this_lang1 = $.trim($('#edit-line-lang1').val())
        line = (time : $(this).attr('data-time'), duration : $(this).attr('data-duration'), lang1 : this_lang1, lang2 : $.trim($('#edit-line-lang2').val()), interpretation_id : interp_id )
      lines.push line)
    $.post('/save', { 'interp_id' : "#{interp_id}", 'lines' : "#{JSON.stringify(lines)}" }, (data) ->
      console.log data )

  $("#preview-button").livequery ->
    $(this).click ->
      save()
      window.location.href = "/interpretations/#{interp_id}?preview=yes"

# AUTOSAVE EVERY 10 SECONDS 

  autosave = setInterval(save, 30000)
