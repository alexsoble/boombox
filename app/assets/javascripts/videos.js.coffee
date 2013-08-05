$ -> 

  if $('#user-id').attr('data-user') isnt 'logged-out'
    window.user_id = $('#user-id').attr('data-user')
  else
    window.user_id = null

  $("body").css("overflow", "hidden")

  $(".page-language-option").click (e) =>
    language_option = e.currentTarget.id

    if language_option is "french-page"
      $("#translate-button").html("Nouvelle vidéo")

    if language_option is "english-page"
      $("#translate-button").html("Translate new video")

  re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})")
  if (re.exec(window.navigator.userAgent) != null)
    console.log "Looks like you're using Internet Explorer!"
    window.location.href = "/browsers"

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
  window.helloArray = helloArray

  # R-T-L ARRAY

  rtlArray = ['Arabic','Persian','Urdu','Sindhi','Hebrew','Yiddish']
  window.rtlArray = rtlArray
