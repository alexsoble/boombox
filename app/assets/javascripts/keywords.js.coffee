$ -> 

  window.keywords = ["despierten", "muera", "recuerde", "quedes", "vayas", "descanse"]

  $('.line').each(->
    for word in keywords
      for i in [0..1]
        this_line = $(this).children().eq(i)
        if this_line.text().indexOf(word) != -1
          keyword_highlighted = this_line.html().replace(word, "<span class='keyword'>#{word}</span>")
          console.log keyword_highlighted
          this_line.html(keyword_highlighted)
  )