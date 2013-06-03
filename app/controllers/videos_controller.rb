class VideosController < ApplicationController
  require 'json'
  respond_to :html, :json

  def create

    @youtube_id = params[:video][:youtube_id]
    if Video.where(:youtube_id => @youtube_id).blank? 
      @video = Video.create(params[:video])
    else
      @video = Video.where(:youtube_id => @youtube_id)
    end

    render :json => { :video => @video }

  end

  def show 

    @video = Video.find_by_id(params[:id])

    @interpretation = Interpretation.where(:video_id => @video.id).first

    if @interpretation.present?
      @lines = Line.where(:interpretation_id => @interpretation.id).order("created_at ASC")
    end
    
  end 

  def index

  end

  def new

  end

end
