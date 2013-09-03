$ -> 

  window.user = $('#user-id').attr('data-user')
  if window.user == "logged-out"
    window.user_id = null
  else
    window.user_id = parseInt(window.user)

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
