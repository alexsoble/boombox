# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  window.volume_slider_on = false

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
        window.volume_slider_on = true
      else
        $('#volume-slider').slider('destroy')
        window.volume_slider_on = false
      
  $('#play-pause').livequery ->
    $(this).click ->
      state = window.player.getPlayerState()
      if state == 1
        player.pauseVideo()
        $(this).html("<i class='icon-play'></i>")
      if state == 2
        player.playVideo()
        $(this).html("<i class='icon-pause'></i>")
