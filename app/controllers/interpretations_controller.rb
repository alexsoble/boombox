class InterpretationsController < ApplicationController
  respond_to :json

  def create 
  
    @video_id = params[:interpretation][:video_id]
    @video = Video.find_by_id(@video_id)

    @interp = Interpretation.create(params[:interpretation])

    render :json => { :data => @interp }

    end

end
