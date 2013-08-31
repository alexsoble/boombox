class PagesController < ApplicationController

  def welcome

    @featured_videos = [
      Interpretation.find(27),
      Interpretation.find(28),
      Interpretation.find(43),
      Interpretation.find(131),
      Interpretation.find(142)
    ]

    interps_with_some_content = []
    Interpretation.all.each do |i|
      l = Line.where(:interpretation_id => i.id).length
      if l > 10
        interps_with_some_content << { :id => i.id, :length => l }
      end
    end
    @interps_with_some_content = []
    interps_with_some_content.sort_by { |hash| hash[:length] }.reverse.take(12).each do |i|
      @interps_with_some_content << Interpretation.find(i[:id])
    end

    @langs_with_some_content = []
    interps_with_some_content.each do |i|
      lang1 = Interpretation.find(i[:id]).video.lang1
      if @langs_with_some_content.index(lang1).blank? 
        @langs_with_some_content << lang1
      end
    @langs_with_some_content = @langs_with_some_content.sort
    end

    @latest_translated_videos = Array.new
    Video.order('created_at DESC').each do |v|
      if v.number_of_interpretations > 0
        @latest_translated_videos << v
      end 
    end
    @latest_translated_videos = @latest_translated_videos[0..9]

    @demo_interps = [Interpretation.find_by_id(43), Interpretation.find_by_id(27), Interpretation.find_by_id(119)]
  end

  def translate
  end

  def philosophy 
  end 
  
  def survey
  end

  def help
  end
  
  def experiment
  end

  def browsers
  end

  def dmca
  end

end
