class VideosController < ApplicationController
  require 'json'
  respond_to :html, :json

  def create

    @youtube_id = params[:video][:youtube_id]
    @lang1 = params[:video][:lang1]
    if Video.where(:youtube_id => @youtube_id).blank? 
      @video = Video.create(params[:video])
    else
      @video2 = Video.where(:youtube_id => @youtube_id).first  # <= You'll want to make this smarter later on.
      if @video2.lang1 != @lang1
        @video = Video.create(params[:video])
      else
        @video = @video2
      end
    end

    render :json => { :video => @video }

  end

  def show 

    @video = Video.find_by_id(params[:id])

    @interpretations = Interpretation.where(:video_id => @video.id).order("created_at ASC")

    if @interpretations.present?

      arr = Array.new 

      @interpretations.each do |i|
        l = Line.where(:interpretation_id => i.id).order("created_at ASC")
        how_many_lines = l.length
        arr << { :id => i.id, :length => how_many_lines }
      end 
      
      arr = arr.sort_by { |hash| hash[:length] }.reverse
      @interpretation = Interpretation.where(:id => arr.first[:id]).first
      @lines = Line.where(:interpretation_id => @interpretation.id).order("created_at ASC")
      @lines_have_lang1 = false
      @lines.all.each do |l|
        if l.lang1.present? then @lines_have_lang1 = true end
      end 

    end
    
  end 

  def index

    # MOST RECENTLY TRANSLATED VIDEOS

    @latest_translated_videos = Array.new

    Video.order('created_at DESC').each do |v|
      if v.number_of_interpretations > 0
        @latest_translated_videos << v
      end 
    end
    
    @latest_translated_videos = @latest_translated_videos[0..9]

    # TOP 10 REQUESTED VIDEOS

    array = Array.new
    @top_requested_videos = Array.new

    Video.order("created_at ASC").each do |v|
      if v.number_of_interpretations == 0
        array << { :id => v.id, :number_of_requests => v.number_of_requests }
      end
    end

    array = array.sort_by { |hash| hash[:number_of_requests] }.reverse[0..9]
    array.each do |h|
      @top_requested_videos << Video.find_by_id(h[:id])
    end

  end

  def new

  end

end
