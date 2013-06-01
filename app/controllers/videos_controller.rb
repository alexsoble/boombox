class VideosController < ApplicationController
  respond_to :html, :json

  def create

    @youtube_id = params[:video][:youtube_id]

    if Video.where(:youtube_id => @youtube_id).blank? 

      @video = Video.new(params[:video])

      if @video.save
        data = "Saved."
      else
        data = "Failed."
      end

      respond_with data

    end

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

end
