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
  window.valuesChanging = false
  window.tool_helptip_displayed = false
  window.editing_line = 'off'
  window.editing_line_timing = 'off'
  window.editing_line_ask_heyu = 'off'
  window.choruslang2 = ''
  $('#timer-box').html('<div id="timer">
    <h2 class="timer-text" id="big-timer"></h2>
    <div style="background-color: #9B59BB; width: 80px;"><small class="white">pause</small></div>
    </div>')

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

  $("#yes-loops").livequery ->
    $(this).click -> 
      window.section = window.time / 4
      window.loop = 4
      $(this).parent().parent().fadeOut()
      sliderSetup()
      loopingPlaybackControls()
      langOneLangTwoStep()

  $("#no-loops").livequery ->
    $(this).click -> 
      $(this).parent().parent().fadeOut()
      sliderSetup()
      nonLoopingPlayback()
      langOneLangTwoStep()

  reportLoopStatus = ->
    if window.loop is false
      $('#loop-status').html("")
      $('#loop-toggle').html("Turn on video looping.")
    else
      $('#loop-status').html("Playing video in loops. Each loop is #{window.loop} seconds long.")
      $('#loop-toggle').html("Turn off video looping.")

  sliderSetup = ->

    $('#settings').append("
      <div id='loop-settings'>
        <div class='left-endLabel'>
          <span class='padded-label'></span>
        </div>
        <div id='loop-slider'></div>
        <div class='right-endLabel'>
          <span class='padded-label'></span>
        </div>
        <span id='loop-status'></span> <a id='loop-toggle'></a>
        <br>
        <span id='set-difficulty'><a>Video difficulty</a></span>
        <div class='controls'>
          <select id='difficulty-settings'>
            <option value='beginner' class='difficulty-setting'>Beginner</option>
            <option value='intermediate' class='difficulty-setting'>Intermediate</option>
            <option value='advanced' class='difficulty-setting'>Advanced</option>
          </select>
        </div>")

  playbackControls = ->
    $('#loop-slider').rangeSlider(
      arrows: false
      step: 1
      defaultValues:
        min: window.time
        max: window.time + 4
      bounds:
        min: Math.floor(window.time / 45) * 45
        max: Math.floor(window.time / 45) * 45 + 60
      range:
        min: 1
        max: 12
      formatter: (val) -> 
        shortFormatTime(val)
      )
      
  loopingPlaybackControls = ->
    playbackControls()

    left_label = $('.left-endLabel').children(':first')
    right_label = $('.right-endLabel').children(':first')
    left_label.html(shortFormatTime(Math.floor(window.time / 45) * 45))
    right_label.html(shortFormatTime(Math.floor(window.time / 45) * 45 + 60))

    $('#loop-slider').children().eq(3).attr('class','ui-rangeSlider-leftLabel playback-slider-label')
    $('#loop-slider').children().eq(4).attr('class','ui-rangeSlider-rightLabel playback-slider-label')

    # GET RID OF ANY JUNK FROM THE STRAIGHTFORWARD PLAYBACK CONTROLLER
    $('#progress-bar').remove()

    $('#loop-slider').bind("valuesChanged", (e, data) ->
      bounds = $('#loop-slider').rangeSlider("bounds")
      min = bounds.min
      max = bounds.max
      start = data.values.min
      end = data.values.max

      shiftRight = -> 
        if end == max and max < window.player.getDuration()
          left_label.text(shortFormatTime(max))
          right_label.text(shortFormatTime(max + 60))
          $('#loop-slider').rangeSlider(
            bounds:
              min: max
              max: max + 60
          ).rangeSlider("values", max + 1, max + 5)

      shiftLeft = -> 
        if start == min and min > 0
          left_label.text(shortFormatTime(min - 60))
          right_label.text(shortFormatTime(min))
          $('#loop-slider').rangeSlider(
            bounds:
              min: min - 60
              max: min
          ).rangeSlider("values", min - 55, min - 59)

      waitForIt = (direction) -> 
        direction()
      if end == max
        window.setTimeout(waitForIt(shiftRight), 1000)
      if start == min
        window.setTimeout(waitForIt(shiftLeft), 1000)
      )

    $('#loop-slider').bind("userValuesChanged", (e, data) ->
        start = data.values.min
        end = data.values.max
        player.seekTo(start)
        window.loop = end - start
        window.section = start / window.loop
        $("#loop-status").html("Playing in a loop from #{shortFormatTime(start)} to #{shortFormatTime(end)}.")
      )

  nonLoopingPlayback = (video_duration) ->
    playbackControls()
    left_label = $('.left-endLabel').children(':first')
    left_label.html(':00')
    $('.ui-rangeSlider-innerBar').prepend("<div id='progress-bar'></div>")
    $('#loop-slider').children().eq(0).children().eq(1).attr('id','straightforward-playback-handle')
    $('.ui-rangeSlider-bar').attr('style','color: white; background-color: #848488;')
    $('.ui-rangeSlider-rightHandle').attr('style','opacity: 0')
    $('.ui-rangeSlider-leftHandle').attr('style','opacity: 0')
    $('#loop-slider').children().eq(3).hide()
    $('#loop-slider').children().eq(4).hide()
    $('#loop-slider').rangeSlider("option", "range", {min: video_duration/20, max: video_duration/20})
    $('#loop-slider').rangeSlider("option", "bounds", {min: 0, max: video_duration})
    $('#loop-slider').bind("valuesChanging", (e, data) ->
      window.valuesChanging = true
      time = data.values.min
      new_width = 368 * time / video_duration
      $('#progress-bar').attr('style',"width: #{new_width}px")
      )
    $('#loop-slider').bind("valuesChanged", (e, data) ->
      window.valuesChanging = false
      time = data.values.min
      window.player.seekTo(time)
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
    helloArray['Sindhi'] = 'سلام'
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

    if window.translation_type == 'lang1_and_lang2'

      $(".lang1-line").livequery ->
        $(this).keyup (e) ->
          entry = this.value
          $('.lyrics-box.small').children().eq(0).html("<p class='white'>#{entry}</p>")
          e.preventDefault
          if e.which == 13 and ($('.lang2-line').val() isnt '')
            $('#lyrics-box').parent().slideDown()
            entry = this.value
            that_entry = $('.lang2-line').val()
            time = $("#current-loop-time").text()
            time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
            $('#lyrics-box').append("
                <div class='line' data-time=#{time_in_seconds} data-duration=#{window.loop}>
                  <div class='lyrics-container'>
                    <p>#{that_entry}</p>
                  </div>
                  <div class='lyrics-container'>
                    <p>#{entry}</p>
                  </div>
                </div>")
            displayTooltip()
            $('#lyrics-box').scrollTo('100%')
            $('.lyrics-box.small').children().eq(0).html("")
            $('.lyrics-box.small').children().eq(1).html("")
            $('#intro-text').fadeOut()
            $('.lang1-line').val('')
            $('.lang2-line').val('')
            window.section += 1
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
            $('#lyrics-box').append("
                <div class='line' data-time=#{time_in_seconds} data-duration=#{window.loop}>
                  <div class='lyrics-container'>
                    <p>#{that_entry}</p>
                  </div>
                  <div class='lyrics-container'>
                    <p>#{entry}</p>
                  </div>
                </div>
                ")
            displayTooltip()
            $('.lyrics-box.small').children().eq(0).html("")
            $('.lyrics-box.small').children().eq(1).html("")
            $('#lyrics-box').scrollTo('100%')
            window.section += 1
            if action_name isnt 'edit'
              $('.lang1-line').val('')
              $('.lang2-line').val('')
              $('.lang1-line').focus()
              $('.preview-button').html('<div class="btn btn-info" id="preview-button">Preview</div>').effect('highlight')

    if window.translation_type == 'just_lang2'

      $(".lang2-line").livequery ->
        $(this).keyup (e) ->
          if e.which == 13
            entry = this.value
            if entry isnt ''
              time = $("#current-loop-time").text()
              $('#lang2-lyrics').append("<p><small><small class='edit-duration'>(#{time})</small></small>  <span class='edit-line-lan2'>#{entry}</span></p>")
              $('.lang2-line').val('')
              time_in_seconds = parseInt(time.slice(3,5)) + parseInt(time.slice(0,2))*60
            window.section += 1
            $('.publish-button').html('<div class="btn btn-info" id="publish-button">Publish!</div>')
            $('.preview-button').html('<div class="btn btn-info" id="preview-button">Preview</div>')

  introText = ->
  
    if action_name isnt 'edit'
      window.player.pauseVideo()
  
    if action_name is 'new'
      $('#controls').html("
      Here we go!<br><br>  Once you've filled in the translation, hit <strong>ENTER</strong> to submit each line. <br><br>
      If you need to look up a word, online dictionaries like <strong><a href='http://www.wordreference.com/'>Wordreference</a></strong> can be a great resource.<br><br>
      Don't worry if you have trouble understanding at first — you'll get tools to help you.<br><br>
      <a href='#' id='input-lines-go'><strong>I'm ready!</strong></a>
      ")

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
    event.target.playVideo()
    video_duration = window.player.getDuration()
    window.video_duration = video_duration
    if window.loop is false
      $('.right-endLabel').children(':first').html(shortFormatTime(video_duration))
      nonLoopingPlayback(video_duration)
    reportLoopStatus()

  countVideoPlayTime = ->

    getTime = ->
      exact_time = player.getCurrentTime()
      window.time = Math.floor(exact_time)
      $(".timer-text").html(formatTime(window.time))

      # STRAIGHTFORWARD (NON-LOOPING) SLIDER AND PROGRESS BAR MOVE HERE
      if window.loop is false and window.valuesChanging is false
        new_width = 368 * window.time / window.video_duration
        $('#progress-bar').attr('style',"width: #{new_width}px")
        $('.ui-rangeSlider-bar').attr('style',"left: #{new_width - 10}px")
    setInterval(getTime, 200)

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
            <div class='btn btn-primary btn-small rounded tight-margins' id='add-line-above' data-line-id=#{id}> &uarr; add new line </div>
            <div class='btn btn-primary btn-small rounded tight-margins' id='add-chorus' data-line-id=#{id}> &uarr; add chorus</div>
          </span>
          <span style='float: right; margin: 10px;' class='toolbox-upper'>
            <div class='btn btn-warning btn-small rounded tight-margins' id='ask-twitter' data-twitter-url='https://twitter.com/share?url=https%3A%2F%2Fdev.twitter.com%2Fpages%2Ftweet-button'> get help from twitter </div>
            <div class='btn btn-warning btn-small rounded tight-margins' id='ask-heyu'> get help from heyu </div>
          </span>
          </span>
          <br>")
        $(this).append("
          <br>
          <span style='float: left; margin: 10px;' class='toolbox-lower'>
            <div class='btn btn-inverse btn-small rounded tight-margins' id='edit-timing'> adjust timing </div>
            <div class='btn btn-inverse btn-small rounded tight-margins' id='delete-line'> delete line </div>
          </span>
          <span style='float: right; margin: 10px;' class='toolbox-lower'>
            <div class='btn btn-success btn-small rounded tight-margins' id='mark-chorus' data-line-id=#{id}> &uarr; set as chorus </div>
            <div class='btn btn-success btn-small rounded tight-margins' id='done-editing'> done editing </div>
          </span>")
        $('#lyrics-box').scrollTo($('.edited-line'))
        $(this).hover(
          -> $(this).attr('style','background-color: #F9F9F9;')
          -> $(this).attr('style','background-color: #F9F9F9;')
          )

  $('#add-line-above').livequery ->
    $(this).click ->
      new_time = parseInt($(this).parent().parent().attr('data-time')) - 4
      $('.edited-line').before("
        <div class='line' data-time=#{new_time} data-duration=4>
          <div class='lyrics-container'>
            <p>New line!</p>
          </div>
          <div class='lyrics-container'>
            <p>New line!</p>
          </div>
        </div>")

  $('#mark-chorus').livequery ->
    $(this).click -> 
      window.choruslang1 = $('#edit-line-lang1').val()
      window.choruslang2 = $('#edit-line-lang2').val()

  $('#add-chorus').livequery ->
    $(this).click -> 
      if window.choruslang2 isnt ''
        new_time = parseInt($(this).parent().parent().attr('data-time')) - 4
        $('.edited-line').before("
          <div class='line' data-time=#{new_time} data-duration=4>
            <div class='lyrics-container'>
              <p>#{window.choruslang1}</p>
            </div>
            <div class='lyrics-container'>
              <p>#{window.choruslang2}</p>
            </div>
          </div>")

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
      url = $(this).attr('data-twitter-url')
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
    $('.edited-line').remove()
    $('#coming-soon').remove()
    $('#loop-settings').slideDown()

  $('#done-editing').livequery ->
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

        $(this).parent().parent().append("
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
            $("#loop-status").html("Playing in a loop from #{shortFormatTime(start)} to #{shortFormatTime(end)}.")
          ).bind("valuesChanging", (e, data) ->
            $('#loop-settings').slideUp()
          )
          $('#lyrics-box').scrollTo('100%')

  # LOOP TOGGLE AND DIFFICULTY SETTINGS 

  $('#loop-toggle').livequery -> 
    $(this).click -> 
      if window.loop == false
        window.loop = 4
        playbackControls()
        loopingPlaybackControls()
        reportLoopStatus()
      else
        window.loop = false
        playbackControls()
        nonLoopingPlayback(video_duration)
        reportLoopStatus()

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

# PREVIEW/SAVE BUTTONS

  save = ->
    lines = []
    $('.line').each(->
      if $(this).attr('class') == 'line'
        line = (time : $(this).attr('data-time'), duration : $(this).attr('data-duration'), lang1 : $.trim($(this).children().eq(0).text()), lang2 : $.trim($(this).children().eq(1).text()), interpretation_id : interp_id )
      else
        line = (time : $(this).attr('data-time'), duration : $(this).attr('data-duration'), lang1 : $.trim($('#edit-line-lang1').val()), lang2 : $.trim($('#edit-line-lang2').val()), interpretation_id : interp_id )
      lines.push line)
    console.log JSON.stringify(lines)
    $.post('/save', { 'interp_id' : "#{interp_id}", 'lines' : "#{JSON.stringify(lines)}" }, (data) ->
      console.log data.data )

  $("#preview-button").livequery ->
    $(this).click ->
      save()
      window.location.href = "/interpretations/#{interp_id}"

# YOUTUBE WINDOW STICKY ON SCROLL

  $window = $(window)
  video_box = $('#outer-video-box')
  video_top = video_box.offset().top
  lyrics_container = $('.lyrics-container')
  $window.scroll ->
    video_box.toggleClass('sticky', $window.scrollTop() > video_top)
    lyrics_container.toggleClass('sticky', $window.scrollTop() > video_top)