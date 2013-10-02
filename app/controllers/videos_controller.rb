class VideosController < ApplicationController
  require 'json'
  respond_to :html, :json

  def create

    @youtube_id = params[:video][:youtube_id]
    if Video.where(:youtube_id => @youtube_id).blank? 
      @video = Video.create(params[:video])
    else
      @video = Video.where(:youtube_id => @youtube_id).first
    end

    render :json => { :video => @video }

  end

  def show 

    @video = Video.find_by_id(params[:id])

    @vocabulary = Word.where(:video_id => @video.id).order("created_at DESC")
    @vocabulary_contributors = []
    @vocabulary.each do |v|
      user = User.where(:id => v.user_id).first
      if @vocabulary_contributors.index(user) == nil then @vocabulary_contributors << user end
    end

    @multiple_choice = Challenge.where(:video_id => @video.id).order("created_at DESC")

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
