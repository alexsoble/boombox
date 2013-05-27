#encoding: utf-8

Video.destroy_all
Interpretation.destroy_all
Line.destroy_all

v = Video.new
v.title = "Eres Tú"
v.url = "http://www.youtube.com/watch?v=sdhep5OaAC0"
v.artist = "Carla Morrison"
v.lang1 = "Spanish"
v.save

v = Video.new
v.title = "Nachspiel"
v.url = "http://www.youtube.com/watch?v=eUtfrSS0oR0"
v.artist = "Chim1"
v.lang1 = "Norwegian"
v.save

  i = Interpretation.new
  i.lang2 = "English"
  i.video_id = v.id
  i.save

v = Video.new
v.title = "Call Me Maybe"
v.url = "http://www.youtube.com/watch?v=fWNaR-rxAic"
v.artist = "Carly Rae Jepsen"
v.lang1 = "English"
v.save

v = Video.new
v.title = "Allez Olla Olé"
v.url = "http://www.youtube.com/watch?v=IX2pxtkhx-M"
v.artist = "Jessy Matador"
v.lang1 = "French"
v.save

  i = Interpretation.new
  i.lang2 = "English"
  i.video_id = v.id
  i.save

    Line.create(:lang1 => "Ola, belle assemblée qui a envie de bouger",
      :lang2 => "Hey people who want to dance",
      :time => 61,
      :interpretation_id => i.id)

    Line.create(:lang1 => "Pour se laisser aller au rythme de l'année",
      :lang2 => "And let yourself go to this year's beat",
      :time => 65,
      :interpretation_id => i.id)

    Line.create(:lang1 => "Allez allez allez, il faut en profiter",
      :lang2 => "Let's go, we should take advantage",
      :time => 69,
      :interpretation_id => i.id)

    Line.create(:lang1 => "C'est une bonne journée et on va la fêter",
      :lang2 => "It's a nice day, we're going to celebrate",
      :time => 72,
      :interpretation_id => i.id)

v = Video.new
v.title = "Thrift Shop"
v.url = "http://www.youtube.com/watch?v=QK8mJJJvaes"
v.artist = "Macklemore"
v.lang1 = "English"
v.save

v = Video.new
v.title = "BOM BOM BOM"
v.url = "http://www.youtube.com/watch?v=k3-BDy55tq4"
v.artist = "Roy Kim"
v.lang1 = "Korean"
v.save

  i = Interpretation.new
  i.lang2 = "English"
  i.video_id = v.id
  i.save

    Line.create(:lang1 => "Bom bom bom bomi wanneyo",
      :lang2 => "Spring, spring, spring, spring has come along",
      :time => 18,
      :interpretation_id => i.id)

    Line.create(:lang1 => "Uriga cheoeum mannatdeon geuttaeui hyanggi geudaero",
      :lang2 => "With that scent of when we first met",
      :time => 22,
      :interpretation_id => i.id)

    Line.create(:lang1 => "Geudaega anja isseotdeon geu benchi yeope namudo ajikdo namainneyo",
      :lang2 => "The tree next to the bench that you sat on is still there",
      :time => 28,
      :interpretation_id => i.id)

    Line.create(:lang1 => "Saragada bomyeon ichyeojil geora haetjiman",
      :lang2 => "I thought I’d forget about it as time went by but",
      :time => 39,
      :interpretation_id => i.id)

    Line.create(:lang1 => "Geu mareul hamyeo andoelgeorangeol algo isseossso",
      :lang2 => "Even as I said that, I knew it wouldn’t happen",
      :time => 44,
      :interpretation_id => i.id)

    Line.create(:lang1 => "Geudaeyeo neoreul cheoeum bon sungan naneun baro aratji",
      :lang2 => "Oh baby, I knew right away when I first saw you",
      :time => 50,
      :interpretation_id => i.id)

    Line.create(:lang1 => "Geudaeyeo nawa hamkke haejuo i bomi gagi jeone",
      :lang2 => "Oh baby, be with me before this spring ends",
      :time => 61,
      :interpretation_id => i.id)
