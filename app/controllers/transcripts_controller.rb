class TranscriptsController < ApplicationController

  def show
    @transcript = Transcript.find_by_slug!(params[:id])
    @user = @transcript.user
    @video = @transcript.video
  end

  def find
    @video = Video.find_by_id(params[:video_id])
    @transcripts = @video.transcripts
    render json: { data: @transcripts }
  end

  def create
    @transcript = Transcript.create(params[:transcript])
    render :json => { :data => @transcript }
  end

end
