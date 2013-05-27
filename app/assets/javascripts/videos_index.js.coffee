$ ->

  $(".language-index-option").click (e) =>
    language_option = e.currentTarget.id
    $(".video-thumb-box").hide()
    $(".video-thumb-box.#{language_option}").show()