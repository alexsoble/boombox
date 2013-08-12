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
    
    # LOGIC TO FIND THE INTERPRETATION WITH THE MOST LINES

    if @interpretations.present?

      arr = Array.new 

      @interpretations.each do |i|
        l = Line.where(:interpretation_id => i.id).order("created_at ASC")
        how_many_lines = l.length
        arr << { :id => i.id, :length => how_many_lines }
      end 
      
      arr = arr.sort_by { |hash| hash[:length] }.reverse
      @interpretation = Interpretation.where(:id => arr.first[:id]).first

      redirect_to "/interpretations/#{@interpretation.id}"      

    end
    
  end 

  def new

    @interp = Interpretation.find_by_id(params[:interp])
    @video = @interp.video
    @translator = User.find_by_id(@interp.user_id)
    @url = request.url
    @lang2 = @interp.lang2
    @lang1 = @video.lang1
    @published = @interp.published
    @lines = Line.where(:interpretation_id => @interp.id).order("created_at ASC")
    @lines.each do |l|
      if l.lang1.present? then @lang1_and_lang2 = true end
    end

    render "interpretations/show"
    
  end

end
