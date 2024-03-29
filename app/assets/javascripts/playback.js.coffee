$ ->

  window.volume_slider_on = false
  window.show_comments = false
  window.show_controls = true

  action_name = $('#data').attr('data-action-name')

  $('#volume').livequery ->
    $(this).click ->
      if window.volume_slider_on == false
        volume = player.getVolume()
        $('#volume-slider').slider(
          value: volume
          min: 0
          max: 100
          animate: true
          orientation: "vertical"
          slide: (event, ui) ->
            player.setVolume(ui.value)
        )
        $('.star').attr('style','right: 117px;')
        if action_name == 'edit'
          $('#volume-slider').addClass('edit')
        window.volume_slider_on = true
      else
        $('#volume-slider').slider('destroy')
        window.volume_slider_on = false
        $('.star').removeAttr('style')

  $('#play-pause').livequery ->
    $(this).click ->
      state = window.player.getPlayerState()
      if state == 1
        player.pauseVideo()
        $(this).html("<i class='icon-play'></i>")
      if state == 2
        player.playVideo()
        $(this).html("<i class='icon-pause'></i>")

  $('#comments-toggle').click ->
    if window.show_comments == false
      $('.comment').slideDown()
      $(this).html('hide comments')
      window.show_comments = true
    else
      $('.comment').slideUp()
      $(this).html('show comments')
      window.show_comments = false

  $('#controls-toggle').click ->
    if window.show_controls == false
      $('#settings').slideDown()
      $(this).html('Hide controls')
      $('#notes-box').removeClass('controls-hidden')
      window.show_controls = true
    else
      $('#settings').slideUp()
      $(this).html('Show controls')
      $('#notes-box').addClass('controls-hidden')
      window.show_controls = false
