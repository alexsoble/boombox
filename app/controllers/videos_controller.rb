class VideosController < ApplicationController

  def new

  end

  def show 

    @video = Video.find_by_id(params[:id])

    @interpretaion = Interpretation.where(:video_id => @video.id).first

    @lines = Line.where(:interpretation_id => @interpretaion.id).order("created_at ASC")
  
  end 

  def index

  end

end
