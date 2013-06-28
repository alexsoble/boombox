$ -> 

  if $('#user-id').attr('data-user') isnt 'logged-out'
    window.user_id = $('#user-id').attr('data-user')
  else
    window.user_id = null

  window.user_id = parseInt($(".signed-in-user").attr('id'))

  $(".page-language-option").click (e) =>
    language_option = e.currentTarget.id

    if language_option is "french-page"
      $("#translate-button").html("Nouvelle vidéo")

    if language_option is "english-page"
      $("#translate-button").html("Translate new video")