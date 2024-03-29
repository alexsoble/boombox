$ ->

  youtube_id = $('#data').attr('data-youtube-id')
  lang1 = $('#data').attr('data-lang-one')
  lang2 = $('#data').attr('data-lang-two')
  interp_id = $('#data').attr('data-interp-id')
  action_name = $('#data').attr('data-action-name')
  translation_type = $('#data').attr('data-translation-type')
  published = $('#data').attr('data-published')
  console.log youtube_id + " " + lang1 + " " + lang2 + " " + interp_id + " " + action_name + " "+ translation_type
  window.lang1 = lang1
  window.lang2 = lang2
  window.interp_id = interp_id 

  if published == 'true' then window.published = true
  if published == 'false' then window.published = false

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

  parseTimeToInt = (time) ->
    split = time.split(/[:]/)
    minutes = parseInt(split[0])
    remainder_seconds = parseInt(split[1])
    total_seconds = minutes * 60 + remainder_seconds
    total_seconds

  window.loop = false
  window.loop_counter = 0
  window.loop_length = 4
  window.looping = false
  window.editing_loop_length = false

  window.valuesChanging = false
  window.tool_helptip_displayed = false
  window.editing_line = false
  window.line_being_edited = false
  window.editing_line_timing = false
  window.loop_length_range_appended = false

  window.quiz_making_mode = false
  window.word_marking_mode = false
  window.quiz_words = []

  $('#timer-box').html('<div id="timer">
    <h2 class="timer-text" id="big-timer"></h2>
    </div>')
  $('#lyrics-box').addClass('short')
  $('#settings').addClass('edit')
  if action_name == 'new'
    $('#notes-box').hide()

  reorderRight = ->
    lines = $('.line')
    lines.sort( (a, b) ->
      parseInt($(a).attr('data-time')) - parseInt($(b).attr('data-time'))
    )
    $('#lyrics-box').html(lines)
    lineEditingLogic()
    
  # ADJUSTING INPUT LINES FOR R-T-L VERSUS L-T-R
  
  if rtlArray.indexOf(window.lang2) > -1
    $('.lang2-line').attr('style','direction: rtl;')
    $('.line').each(->
      $(this).children().eq(1).addClass('right-to-left')
    )
  if $('.lang1-line').length > 0
    if rtlArray.indexOf(window.lang1) > -1
      $('.lang1-line').attr('style','direction: rtl;') 
      $('.line').each(->
        $(this).children().eq(0).addClass('right-to-left')
      )

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
        <a class="btn btn-info center-pill rounded" id="go-back" style="position: absolute; top: 168px; left: 168px;">Go back</a>
      </div>')
    $("#controls").fadeIn('slow')
  if action_name is 'new'
    $('.lyrics-container').hide()
    $('.lyrics-container').hide()
    $('.input-line-container').hide()
  # $('#timer').hide()

  $("#start").livequery ->
    $(this).click -> 
      $('#settings').slideDown()
      window.player.pauseVideo()
      $(this).remove()
      $('#timer-box').show()

      # EXPLANATION FOR HOW LOOPS WORK POPS UP HERE

      $("#controls").html("
      <div>
        <h3><strong>Heads up: It's hard to translate at the same speed as the video!</strong></h3>
        <br>
        <p>Don't worry though. Heyu will help you break up the video into shorter segments called loops.</p>
        <br>
        <p>Listen to each loop as many times as you need to get the meaning!</p>
        <br>
        <p>You can use the blue handles to choose the loop you want to translate:</p>
          <div class='btn btn-primary btn-small rounded'> :00 </div> 
          <div class='btn btn-primary btn-small rounded'> :04 </div> 
        <br>
        <p>Or you can manually enter the start and end times of the loop you want to work on:</p>
          <input type='text' class='loop-input-box' value='00:00'></input>
          <input type='text' class='loop-input-box' value='00:04'></input>
        </br><br>
        <label class='checkbox'><input type='checkbox' id='yes-loops'><h3>Sounds good!</h3></label>
      </div>")

  $("#go-back").livequery ->
    $(this).click -> 
      window.location.href = "/welcome?interp=#{interp_id}"

  $('#word-marking-mode').livequery ->
    $(this).click ->
      if window.word_marking_mode == false
        window.word_marking_mode = true
        $(this).text('marking key words')
      else
        window.word_marking_mode = false
        $(this).text('mark key words')

  $('.dropdown-toggle').click ->
    $('#settings').slideUp()
    player.pauseVideo()

  $('.dropdown-option').click ->
    $('#settings').slideDown()

  $('#add-note').livequery ->
    $(this).click ->
      $('.edit-button-suite').replaceWith("
        <div id='edit-note-area'>
          <textarea id='note-input' style='width: 370px; height: 60px;'/>
          <br>
          <div class='btn btn-info btn-small btn-tiny rounded' id='done-with-note'> done </div>
        </div>
      ")
      player.pauseVideo()

  $('#edit-note').livequery ->
    $(this).click ->
      current_note = $('#note-text').text()
      $('#notes-box').html("
        <div id='edit-note-area'>
          <textarea id='note-input' style='width: 370px; height: 60px;'/>
          <br>
          <div class='btn btn-info btn-small btn-tiny rounded' id='done-with-note'> done </div>
        </div>
      ")
      $('#note-input').html(current_note)
      player.pauseVideo()

  $('#done-with-note').livequery ->
    $(this).click ->
      note = $('#note-input').val()
      $.post('/update_note', { 'id' : '#{window.interp_id}', 'note' : '#{note}' })
      $('#edit-note-area').replaceWith("
          <p id='note'><strong>Your note: &nbsp;</strong>
            <span id='note-text'>#{note}</span>
          </p>
          <div class='edit-button-suite'>
            <div class='btn-group'>
              <div class='btn btn-info btn-small rounded dropdown-toggle' data-toggle='dropdown'> teaching tools </div>
              <ul class='dropdown-menu'>
                <li><a href='#' id='word-marking-mode' class='dropdown-option'> mark key words </a></li>
                <li><a href='#' id='edit-note' class='dropdown-option'> edit note </a></li>
              </ul>
            </div>
            <div class='btn-group'>
              <div class='btn btn-info btn-small rounded dropdown-toggle' data-toggle='dropdown'> help </div>
              <ul class='dropdown-menu'>
                <li><a href='#' id='instructions-button' class='dropdown-option'> editing tips </a></li>
              </ul>
            </div>
            <div class='btn-group'>
              <div class='btn btn-info btn-small rounded dropdown-toggle' data-toggle='dropdown'> print </div>
              <ul class='dropdown-menu'>
                <li><a href='#' id='print-pdf' class='dropdown-option'> print pdf </a></li>
                <li><a href='#' id='print-txt' class='dropdown-option'> print .txt </a></li>
              </ul>
            </div>
          </div>
          ")
      player.playVideo()

  $("#yes-loops").livequery ->
    $(this).click -> 
      window.loop = true
      window.section = window.time / 4
      $(this).parent().parent().fadeOut()
      sliderSetup()
      checkDurationViaYouTubeAPI()
      langOneLangTwoStep()

  setNewLoop = (time, part_being_edited) ->
    new_time = parseTimeToInt(time)
    values = $('#playback-slider').rangeSlider("values")
    if window.loop == false then window.loop = true
    if part_being_edited == 'start'
      if values.max > new_time > -1
        player.seekTo(new_time)
        $('#playback-slider').rangeSlider("values", new_time, values.max)
        $('.loop-handle-label.ui-rangeSlider-leftLabel .inner-label').html("#{shortFormatTime(new_time)}")
        $('.loop-handle-label.ui-rangeSlider-rightLabel .inner-label').html("#{shortFormatTime(values.max)}")
        $('.current-loop-start').val(formatTime(new_time))
        window.loop_length = values.max - new_time
        window.section = new_time / window.loop_length
      else if new_time >= values.max
        window.player.seekTo(new_time)
        $('#playback-slider').rangeSlider("values", new_time, new_time + window.loop_length)
        $('.loop-handle-label.ui-rangeSlider-leftLabel .inner-label').html("#{shortFormatTime(new_time)}")
        $('.loop-handle-label.ui-rangeSlider-rightLabel .inner-label').html("#{shortFormatTime(new_time + window.loop_length)}")
        $('.current-loop-start').val(formatTime(new_time))
        $('.current-loop-end').val(formatTime(new_time + window.loop_length))
        window.section = new_time / window.loop_length
    if part_being_edited == 'end'
      if window.video_duration > new_time > values.min
        window.loop_length = new_time - values.min
        $('#playback-slider').rangeSlider("values", values.min, new_time)
        $('.loop-handle-label.ui-rangeSlider-leftLabel .inner-label').html("#{shortFormatTime(values.min)}")
        $('.loop-handle-label.ui-rangeSlider-rightLabel .inner-label').html("#{shortFormatTime(new_time)}")
        $('.current-loop-end').val(formatTime(new_time))
        window.loop_length = new_time - values.min
        window.section = values.min / window.loop_length

  $('.lang1-line').focusout ->
    $('.lang2-line').focus()

  $('.loop-length-input').focusin ->
    window.editing_loop_length = true
  $('.loop-edit-input').focusin ->
    window.editing_loop_length = true

  $('.loop-length-input').focusout ->
    time = $(this).val()
    if $(this).hasClass('current-loop-start') then part_being_edited = 'start'
    if $(this).hasClass('current-loop-end') then part_being_edited = 'end'
    setNewLoop(time, part_being_edited)
  $('.loop-length-input').keyup (e) ->
    e.preventDefault
    if e.which == 13
      console.log "New loop times!"
      time = $(this).val()
      if $(this).hasClass('current-loop-start') then part_being_edited = 'start'
      if $(this).hasClass('current-loop-end') then part_being_edited = 'end'
      setNewLoop(time, part_being_edited)

  editExistingLoop = (time, part_being_edited, line_id) ->
    new_time = parseTimeToInt(time)
    line = $("##{line_id}")
    current_start = line.attr('data-time')
    current_end = current_start + parseInt(line.attr('data-duration'))
    if part_being_edited == 'start'
      if current_end > new_time > -1
        window.player.seekTo(new_time)
        line.attr("data-time","#{new_time}")
        window.loop_length = current_end - new_time
        window.section = new_time / window.loop_length
      else if new_time >= current_end
        window.player.seekTo(new_time)
        line.attr("data-time","#{new_time}")
        line.attr("data-duration","#{new_time + window.loop_length}")
        $('.editing-loop-end').val(formatTime(new_time + window.loop_length))
    if part_being_edited == 'end'
      if window.video_duration > new_time > current_start
        line.attr("data-duration","#{new_time - current_start}")
        window.loop_length = new_time - current_start
        window.section = current_start / window.loop_length
    window.editing_line_timing = false

  $('.loop-edit-input').livequery ->
  	$(this).focusout ->
    	time = $(this).val()
    	if $(this).hasClass('editing-loop-start')
    		part_being_edited = 'start'
    	if $(this).hasClass('editing-loop-end')
    		part_being_edited = 'end'
    	line_id = $(this).parent().parent().attr('id')
    	editExistingLoop(time, part_being_edited, line_id)
  	$(this).keyup (e) ->
	    e.preventDefault
	    if e.which == 13 then 
				if $(this).hasClass('editing-loop-start') then part_being_edited = 'start'
				if $(this).hasClass('editing-loop-end') then part_being_edited = 'end'
				line_id = $(this).parent().parent().attr('id')
				time = $(this).val()
				editExistingLoop(time, part_being_edited, line_id)

  sliderSetup = ->

    $('#notes-box').append("
      <div id='instructions' class='quiet'>
        <p>Tips: 
          <ul>
            <li>Use the <div class='btn btn-primary btn-small rounded'> :00 </div> 
              <div class='btn btn-primary btn-small rounded'> :04 </div> handles to select each line of the video you want to translate.</li>
            <br>
            <li>Use the <div class='btn btn-info btn-small rounded tight-pack'> + </div>
              <div class='btn btn-info btn-small rounded tight-pack'> - </div> buttons to make the video loop over the line you're translating so that you can listen closely.</li>
            <br>
            <li> Hit the <div class='btn btn-info btn-small rounded tight-pack'> loop x times </div> button to make the video loop a few more times.</li>
          </ul>
        </p>
      </div>")

    $('#print-pdf').click ->
      window.location.href = "/print_pdf/#{window.interp_id}"
    $('#print-txt').click ->
      window.location.href = "/print_txt/#{window.interp_id}"
    $('#print-google').click ->
      window.location.href = "/print_google/new/#{window.interp_id}"

    $('#instructions-button').click ->
      $("#instructions").dialog()      

    $('#settings').append("
      <div id='playback-buttons' class='upper-left-btn'>
        <div class='btn btn-info btn-small rounded tight-pack' id='play-loop-again'> 
          <i class='icon icon-refresh'></i>
          Play loop again 
        </div>
        <div class='btn btn-info btn-small rounded tight-pack' id='play-no-loops'> 
          <i class='icon icon-play'></i>
          Play, don't loop 
        </div>
        <div class='btn btn-info btn-small btn-tiny rounded tight-pack' id='pause'> 
          <i class='icon-pause'></i> 
        </div>
        <div class='btn btn-info btn-small btn-tiny rounded tight-pack' id='volume'> 
          <div id='volume-slider'> </div>
          <i class='icon-volume-up'></i> 
        </div>
      </div>
      <div class='playback-left-label end-label'><div class='playback-left-label inner-label'></div></div>
        <div id='playback-slider'></div>
      <div class='playback-right-label end-label'><div class='playback-right-label inner-label'></div></div>
      <div id='tracker'></div>
      ")

  $('#play-loop-again').livequery ->
    $(this).click ->
      window.loop = true
      player.seekTo(window.loop_length * window.section).playVideo()

  $('#play-no-loops').livequery ->
    $(this).click ->
      window.loop = false
      player.playVideo()

  $('#pause').livequery ->
    $(this).click ->
      player.pauseVideo()

  playbackControls = (video_duration) ->

    $('.playback-left-label.inner-label').html(":00")
    $('.playback-right-label.inner-label').html("#{shortFormatTime(video_duration)}")

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
        min: 1
        max: video_duration / 3 
      formatter: (val) -> 
        shortFormatTime(val))

    $('#playback-slider').children().eq(3).addClass('loop-handle-label')
    $('#playback-slider').children().eq(4).addClass('loop-handle-label')

    $('.loop-handle-label.ui-rangeSlider-leftLabel').html("
      <div class='inner-label'>#{shortFormatTime($('#playback-slider').rangeSlider("values").min)}</div>
      ")
    $('.loop-handle-label.ui-rangeSlider-rightLabel').html("
      <div class='inner-label'>#{shortFormatTime($('#playback-slider').rangeSlider("values").max)}</div>
      ")
    
    $('#playback-slider').on("valuesChanging", (e, data) ->
      window.valuesChanging = true
      start = data.values.min
      end = data.values.max
      player.seekTo(start)
      window.loop_length = end - start
      window.section = start / window.loop_length
      $('.ui-rangeSlider-leftLabel.loop-handle-label .inner-label').html("#{shortFormatTime(start)}")
      $('.ui-rangeSlider-rightLabel.loop-handle-label .inner-label').html("#{shortFormatTime(end)}")
      if window.editing_line == false
        $('.current-loop-start').val(formatTime(start))
        $('.current-loop-end').val(formatTime(end))
      else
        $('.editing-loop-start').val(formatTime(start))
        $('.editing-loop-end').val(formatTime(end))
    )

    $('#playback-slider').on("valuesChanged", (e, data) ->
      player.playVideo()
      if window.editing_line == true
        editExistingLoop(formatTime(data.values.min), 'start', window.line_being_edited)
        editExistingLoop(formatTime(data.values.max), 'end', window.line_being_edited)
    )

  langOneLangTwoStep = ->

    if window.player.getOptions().indexOf('cc') > -1
      window.cc_status = "Which this video does!"
    else
      window.cc_status = "Unfortunately, this video doesn't have captions."

    $("#controls").html("
      <h3>One question before we get started!</h3>
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
        if window.loop_length != false 
          if window.loop_length * window.section > time
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

      current_loop_start = $('#playback-slider').rangeSlider("values").min
      duration = $('#playback-slider').rangeSlider("values").max - current_loop_start

      correct_line.after("
        <div class='line rounded' data-time=#{current_loop_start} data-duration=#{duration}>
          <div class='lyrics-container'>
            <p>#{lang1}</p>
          </div>
          <div class='lyrics-container'>
            <p>#{lang2}</p>
          </div>
        </div>")

      correct_line.next().effect("highlight", {}, 10000)
      $('#notes-box').slideDown()
      resetForNextLine(current_loop_start + duration)

    moveLoopForward = (next_line_start) -> 
      $('#playback-slider').rangeSlider("values", next_line_start, next_line_start + window.loop_length)
      $('.ui-rangeSlider-leftLabel.loop-handle-label .inner-label').html("#{shortFormatTime(next_line_start)}")
      $('.ui-rangeSlider-rightLabel.loop-handle-label .inner-label').html("#{shortFormatTime(next_line_start + window.loop_length)}")
      $('.current-loop-start').val(formatTime(next_line_start))
      $('.current-loop-end').val(formatTime(next_line_start + window.loop_length))
      window.player.seekTo(next_line_start)
      window.loop_counter = 0
      player.playVideo()

    # PROGRESS REPORT
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
      $('#progress-report').html("You've translated #{number_of_loops} loops, totalling #{total_seconds} out of #{total_seconds}, or approximately #{percentage} of the video. #{status}")

    resetForNextLine = (next_line_start) -> 
      $('#lyrics-box').scrollTo('100%')
      $('#intro-text').fadeOut()
      $('.lang1-line').val('')
      $('.lang2-line').val('')
      $('.lang1-line').focus()
      window.section += 1
      displayTooltip()
      moveLoopForward(next_line_start)

    $(".lang1-line").livequery ->
      $(this).keyup (e) ->
        if e.which == 13 and ($('.lang2-line').val() isnt '')
          entry = this.value
          that_entry = $('.lang2-line').val()
          addNewLineInRightPlace(entry, that_entry)

    $(".lang2-line").livequery ->
      $(this).keyup (e) ->
        if e.which == 13 and ($('.lang1-line').val() isnt '')
          entry = this.value
          that_entry = $('.lang1-line').val()
          addNewLineInRightPlace(that_entry, entry)

    $('#next-line').click ->
      this_entry = $('.lang1-line').val()
      that_entry = $('.lang2-line').val()
      if this_entry isnt '' and that_entry isnt ''
        addNewLineInRightPlace(this_entry, that_entry)

  introText = ->
  
    if action_name isnt 'edit'
      window.player.pauseVideo()
  
    if action_name is 'new'
      if window.user_id == null
        $('#controls').html("
          <br><br>
          <strong>Here we go!</strong><br><br>
          Be sure to <strong><a href='/join?interp=#{interp_id}'>sign up for a Heyu account</strong></a> if you'd like to save or publish your translation.<br><br>
          <h3><a href='#' id='input-lines-go'><strong>I'm ready!</strong></a></h3>")
      else
        $('#controls').html("
        <br><br><br><br>
        <a class='btn btn-info btn-large center-pill rounded' id='input-lines-go' style='position: absolute; left: 108px;'>I'm ready!</a>")

    $("#input-lines-go").livequery -> 
      $(this).click ->
        $('#controls').slideUp()
        $('.lyrics-container').slideDown()
        $('.input-line-container').slideDown()
        window.player.playVideo()

# VIDEO DURATION CAN'T BE ZERO

  checkDurationViaYouTubeAPI = ->
    $.ajax(
      url: "https://gdata.youtube.com/feeds/api/videos/#{youtube_id}?v=2&alt=json"
      type: "GET"
      dataType: "json",
      complete: (r) ->
        data = JSON.parse(r.responseText)
        video_duration = data.entry.media$group.media$content[0].duration
        playbackControls(video_duration)
        window.video_loaded = true
        console.log "PLAYBACK CONTROLS LOADED! VIDEO DURATION = #{video_duration}"
       )

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
        wmode: "opaque"
        }
      events:
        onReady: onPlayerReady
        onStateChange: onPlayerStateChange })
    console.log "Checking for cc..." + player.getOptions().indexOf('cc')
    window.player = player

  onPlayerReady = (event) ->
    inputLineLogic()
    video_duration = window.player.getDuration()
    console.log "VIDEO DURATION = #{video_duration}!"
    window.video_duration = video_duration
    event.target.playVideo()

    # VIDEO DURATION CAN'T BE ZERO

    if video_duration == 0
      checkDurationViaYouTubeAPI()
    else
      window.video_loaded = true
      playbackControls(window.video_duration)
      console.log "PLAYBACK CONTROLS LOADED!"

  countVideoPlayTime = ->

    if window.video_loaded == true
      exact_time = player.getCurrentTime()
      window.time = Math.floor(exact_time)
      $(".timer-text").html(formatTime(window.time))
      this_line = $("[data-time=#{window.time}]")

      current_loop_start = $('#playback-slider').rangeSlider("values").min
      current_loop_end = $('#playback-slider').rangeSlider("values").max

      if window.editing_loop_length == false
        $(".current-loop-start").val(formatTime(current_loop_start))
        $(".current-loop-end").val(formatTime(current_loop_end))

      tracker_position = window.time * 313 / window.video_duration
      $('#tracker').attr("style","left: #{50 + tracker_position}px")

      # PLAYBACK SLIDER MOVES HERE
      # if window.loop == false and window.valuesChanging == false
        # $('#playback-slider').rangeSlider("values", window.time, window.time + 4)
        # $('.loop-handle-label.ui-rangeSlider-leftLabel .inner-label').html("#{shortFormatTime(window.time)}")
        # $('.loop-handle-label.ui-rangeSlider-rightLabel .inner-label').html("#{shortFormatTime(window.time + 4)}")

      # LOOPING HAPPENS HERE

      loopNow = ->
        loopingNow = ->
          player.seekTo(window.loop_length * window.section, true)
          player.setVolume(window.volume)
          player.pauseVideo()
          startUpAgain = ->
            player.pauseVideo()
            window.looping = false
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
      modifier = .69 + (window.loop_length * 0.015)
      if window.loop == true and window.time > (window.loop_length) * (window.section + modifier) and window.looping == false
        window.looping = true
        fadeOut()
        loopNow()
        window.loop_counter += 1

      # TRANSLATED LINES LIGHT UP HERE AS THE VIDEO PLAYS
      if this_line.length != 0 and window.editing_line == false
        unless this_line.hasClass('highlighted')
          this_line.effect("highlight", { color: "yellow" }, 4000)
          this_line.addClass("highlighted")
          if this_line.prev().prev().length != 0
            $("#lyrics-box").scrollTo(this_line.prev().prev(), { duration : 250 } )
          else
            if this_line.prev().length != 0
              $("#lyrics-box").scrollTo(this_line.prev(), { duration : 250 } )
            else
              $("#lyrics-box").scrollTo(this_line, { duration : 250 } )

  counter = setInterval(countVideoPlayTime, 250)
  done = false

  onPlayerStateChange = (event) ->
    if event.data == YT.PlayerState.PAUSED
      exact_time = player.getCurrentTime()
      window.time = Math.round(exact_time)
      window.section = window.time / window.loop_length

  delayedShow = -> 
    window.player.playVideo()
  window.setTimeout(delayedShow, 1000)

  doneEditing = ->
    window.editing_line = false
    window.editing_line_timing = false
    window.editing_line_ask_heyu = false
    $('.input-line-container').show()
    line_id = $('.edited-line').attr('id')
    time = $('.edited-line').attr('data-time')
    duration = $('.edited-line').attr('data-duration')
    lang1 = $('#edit-line-lang1').val()
    lang2 = $('#edit-line-lang2').val()
    $('.edited-line').before("
      <div class='line rounded' id=#{line_id} data-time=#{time} data-duration=#{duration}>
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
    reorderRight()

  editLine = (this_line) ->
    window.editing_line = true
    id = parseInt(this_line.attr('id'))
    window.line_being_edited = id
    this_line.addClass('edited-line')
    $('.input-line-container').hide()
    lang1 = $.trim(this_line.children().eq(0).text())
    lang2 = $.trim(this_line.children().eq(1).text())
    start_time = parseInt(this_line.attr('data-time'))
    end_time = start_time + parseInt(this_line.attr('data-duration'))
    $('#playback-slider').rangeSlider("values", start_time, end_time)
    $('.loop-handle-label.ui-rangeSlider-leftLabel .inner-label').html("#{shortFormatTime(start_time)}")
    $('.loop-handle-label.ui-rangeSlider-rightLabel .inner-label').html("#{shortFormatTime(end_time)}")
    this_line.html("
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
    this_line.prepend("
      <span style='float: left; margin: 10px;' class='toolbox-upper'>
        <div class='btn btn-small btn-primary rounded tight-margins' style='background-color: white; border: solid 1px; border-color: black; color: black;'> Adjust timing: </div>
        <input type='text' class='loop-input-box loop-edit-input editing-loop-start' value='#{formatTime(start_time)}' /> to 
        <input type='text' class='loop-input-box loop-edit-input editing-loop-end' value='#{formatTime(end_time)}' />
      </span>
      <span style='float: right; margin: 10px;' class='toolbox-upper'>
        <div class='btn btn-primary btn-small rounded tight-margins' id='copy-paste'> Copy/paste this line </div>
        <div class='btn btn-primary btn-small rounded tight-margins' id='ask-twitter'> Get help from Twitter </div>
      </span>
      </span>
      <br>")
    this_line.append("
      <br>
      <span style='float: right; margin: 10px;' class='toolbox-lower'>
      </span>
      <span style='float: left; margin: 10px;' class='toolbox-lower'>
        <div class='btn btn-small btn-primary rounded tight-margins' id='done-editing' style='background-color: white; border: solid 1px; border-color: black; color: black;'> Done editing </div>
        <div class='btn btn-inverse btn-small rounded tight-margins' id='delete-line' data-line-id=#{id}> Delete line </div>
      </span>")
    this_line.attr('style','background-color: #DFE0E2')
    $('#lyrics-box').scrollTo($('.edited-line'))

  # REVISING LINE CONTENT 

  lineEditingLogic = ->
    $('.line').livequery ->
      $(this).hover(
        -> if window.quiz_making_mode == false and window.word_marking_mode == false and window.editing_line == false then $(this).attr('style','background-color: yellow;')
        -> if window.editing_line == false then $(this).attr('style','background-color: white;')
        )
      $(this).click ->
        if window.word_marking_mode == false
          if window.editing_line == true
            unless parseInt($(this).attr('id')) == window.line_being_edited
              doneEditing()
              editLine($(this))
          else
            editLine($(this))

  editingSuiteLogic = ->

    $('#copy-paste').livequery ->
      $(this).click -> 
        $('.lang1-line').val($('#edit-line-lang1').val())
        $('.lang2-line').val($('#edit-line-lang2').val())
        doneEditing()

    $('p').livequery ->
      $(this).hover -> 
        if window.word_marking_mode == true and $(this).attr('class') != 'lettered'
          $(this).lettering('words')
          $(this).addClass('lettered')
        if window.quiz_making_mode == true and $(this).attr('class') != 'lettered'
          $(this).lettering('words')
          $(this).addClass('lettered')

    $('[class^="word"]').livequery ->
      $(this).click ->
        this_word = $(this)
        if this_word.hasClass('keyword')
          this_word.removeClass('keyword')
          $.post('/remove_keyword', { 'keyword' : { 'interpretation_id' : "#{window.interp_id}", 'user_id' : "#{window.user_id}", 'word_text' : "#{this_word.text()}" } }, (data) ->
            console.log data
            $('.line').each(->
              this_line = $(this).children().eq(0)
              word = this_word.text()
              if this_line.text().indexOf(word) != -1
                console.log this_line.text()
                console.log word
                keyword_highlighted = this_line.html().replace(word, "<span class='keyword'>#{word}</span>")
                this_line.html(keyword_highlighted)
              )
            ) 

        else
          this_word.addClass('keyword')
          $.post('/create_keyword', { 'keyword' : { 'interpretation_id' : "#{window.interp_id}", 'user_id' : "#{window.user_id}", 'word_text' : "#{this_word.text()}" } }, (data) ->
            console.log data
            $('.line').each(->
              this_line = $(this).children().eq(0)
              word = this_word.text()
              if this_line.text().indexOf(word) != -1
                console.log this_line.text()
                console.log word
                keyword_highlighted = this_line.html().replace(word, "<span class='keyword'>#{word}</span>")
                this_line.html(keyword_highlighted)
            ) 
          )

    $('#delete-line').livequery ->
      $(this).click ->
        console.log "deleting line"
        window.editing_line = false
        line_id = $(this).attr('data-line-id')
        $(this).parent().parent().slideUp()
        # ^The slideUp would be nice but unfortunately js from YouTube/Google interferes with a delayed remove() and mucks up the whole thing
        $(this).parent().parent().remove()
        $('.input-line-container').slideDown()

    $('.edit-line').livequery ->
      $(this).keyup (e) ->
        e.preventDefault
        if e.which == 13 and this.value isnt ''
          doneEditing()

    $('#ask-twitter').livequery ->
      $(this).click ->
        start = parseInt($(this).parent().parent().attr('data-time'))
        duration = parseInt($(this).parent().parent().attr('data-duration'))
        $.post('/new_clip', { 'clip' : { 'start' : "#{start}", 'duration' : "#{duration}", 'interpretation_id' : "#{window.interp_id}" } }, (data) ->
          id = data.data.id
          window.location.href = "/clips/#{id}"
        )

    $('#ask-heyu').livequery ->
      $(this).click ->
        if window.editing_line_ask_heyu isnt true
          $(this).parent().parent().after("
            <span id='coming-soon' style='float: left; background-color: orange; width: 500px;'>
              <span style='margin: 10px;'>
                <strong>Coming soon</strong>: compare your translation with other Heyu users'.
              </span>
            </span>
            ")
          window.editing_line_ask_heyu = true

    $('#done-editing').livequery ->
      $(this).click ->
        doneEditing()

    $('#done-editing-time').livequery ->
      $(this).click ->
        doneEditing()
  
  editingSuiteLogic()
  lineEditingLogic()

# PREVIEW/SAVE BUTTONS

  save = ->
    lines = []
    $('.line').each(->
      this_line = $(this)
      this_id = $(this).attr('id')

      # GATHER THE CURRENT TRANSLATION WITH JQUERY
      unless this_line.hasClass('edited-line')
        this_lang1 = $.trim(this_line.children().eq(0).text())
        this_lang2 = $.trim(this_line.children().eq(1).text())

      # IF THE USER IS CURRENTLY EDITING A LINE, LET'S CAPTURE ITS VALUE TOO
      else
        this_lang1 = $.trim($('#edit-line-lang1').val())
        this_lang2 = $.trim($('#edit-line-lang2').val())

      line = (id : this_id, time : this_line.attr('data-time'), duration : this_line.attr('data-duration'), lang1 : this_lang1, lang2 : this_lang2, interpretation_id : interp_id )
      
      lines.push line
      
      )

    # TRANSLATION PASSED TO RAILS TO EVALUATE IF IT'S BEEN UPDATED
    $.post('/save', { 'interp_id' : "#{interp_id}", 'lines' : "#{JSON.stringify(lines)}" }, (data) ->
      console.log data )

  $("#all-done").livequery ->
    $(this).click ->
      if window.user_id == null
        window.location.href = "/join?interp=#{interp_id}"
      else
        save()
        window.location.href = "/interpretations/#{interp_id}/"

# AUTOSAVE EVERY 10 SECONDS 

  autosave = setInterval(save, 30000)
