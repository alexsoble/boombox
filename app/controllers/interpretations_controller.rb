class InterpretationsController < ApplicationController
  respond_to :json, :html

  def create 
  
    @video_id = params[:interpretation][:video_id]
    @video = Video.find_by_id(@video_id)

    @interp = Interpretation.create(params[:interpretation])

    render :json => { :data => @interp }

  end

  def index

    @interps = Interpretation.order('created_at DESC').limit(100)
    @language_filter = params[:lang]
  
  end

end
