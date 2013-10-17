class TranscriptsController < ApplicationController

  def find
    @video = Video.find_by_id(params[:video_id])
    @transcripts = Transcript.where(:video_id => @video.id).all
    render json: { data: @transcripts }
  end

  def create
    @transcript = Transcript.create(params[:transcript])
    render :json => { :data => @transcript }
  end

end
