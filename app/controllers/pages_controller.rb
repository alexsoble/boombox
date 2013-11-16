class PagesController < ApplicationController

  before_filter :authorize, only: :admin

  def authorize
    unless current_user
      redirect_to '/welcome' 
      false
    else
      unless current_user.id == 8
        redirect_to '/welcome' 
        false        
      end
    end
  end

  def welcome

    @languages_with_videos = []

    Tag.all.each do |t|
      unless @languages_with_videos.index(t.language).present?
        @languages_with_videos << t.language 
      end
    end

    @featured_video_1 = Video.find(25)
    @featured_video_2 = Video.find(85)
    @featured_video_3 = Video.find(132)
    @featured_video_4 = Video.find(24)

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
    redirect_to "/interpretations/alex-heyu-start-up-chile-video"
  end

  def embed_styling
    render file: 'pages/embed.css'
  end

  def admin
  end

  def new
  end

  def philosophy 
  end 
  
  def survey
  end

  def help
  end
  
  def experiment
    # Los Rakas video
    # @transcript = Transcript.find_by_id(67)
    # @video = @transcript.video

    # Kambiz Hosseini video
    # @video = Video.find_by_id(234)

    # James Blake
    @video = Video.find_by_id(235)
  end

  def teachers
  end

  def browsers
  end

  def dmca
  end

  def earlyadopters
    @lanes_interpretation = Interpretation.find_by_id(248)
    @michaels_fill_exercise = FillExercise.find_by_id(16)
    @kelseys_fill_exercise = FillExercise.find_by_id(12)
    @alex = User.find_by_id(8)
  end

  def help
  end

  def globe
    globe = File.read("d3/world-110m.json")
    render json: globe
  end

  def countries
    countries = File.read("d3/world-country-names.tsv")
    render json: countries
  end
end
