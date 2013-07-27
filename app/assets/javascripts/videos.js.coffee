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
