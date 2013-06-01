$ -> 

  $(".page-language-option").click (e) =>
    language_option = e.currentTarget.id

    if language_option is "french-page"
      $("#translate-button").html("Nouvelle vidéo")

    if language_option is "english-page"
      $("#translate-button").html("Translate new video")