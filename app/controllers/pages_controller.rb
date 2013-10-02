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

    @latest_translated_videos = Array.new
    Video.order('created_at DESC').each do |v|
      if v.number_of_interpretations > 0
        @latest_translated_videos << v
      end 
    end
    @latest_translated_videos = @latest_translated_videos[0..9]

    if params[:interp].present?
      @interp = Interpretation.find_by_id(params[:interp])
      @youtube_id = @interp.video.youtube_id
      @title = @interp.video.title
    end

  end

  def terms
    if params[:from].present?
      @from_join_page = true
    else
      @from_join_page = false
    end
  end

  def chile
    redirect_to :controller => 'interpretations', :action => 'show', :id => '155'
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
    render 'interpretations#edit'
  end

  def browsers
  end

  def dmca
  end

end
