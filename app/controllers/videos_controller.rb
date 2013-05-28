class VideosController < ApplicationController

  def new

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
