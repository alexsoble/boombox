class TranscriptsController < ApplicationController

  def show
    @transcript = Transcript.find_by_slug!(params[:id])
    @timed_lines = @transcript.lines.reject { |l| l.time.blank? }.sort { |a, b| a.time <=> b.time }
    @untimed_lines = @transcript.lines.reject { |l| l.time.present? }.sort { |a, b| a.ordering <=> b.ordering }

    @user = @transcript.user
    @video = @transcript.video

    if current_user
      @transcript.stars.each { |s| if s.user_id == current_user.id then @star = s end }
    end 

    @translations = @transcript.translations

  end

  def find

    if params[:video_id].present?
      @video = Video.find_by_id(params[:video_id])
      @transcripts = @video.transcripts
      render json: { data: @transcripts }
    end

    if params[:id].present?
      @transcript = Transcript.find_by_id(params[:id])
      render json: { data: @transcript }
    end
    
  end

  def create
    @transcript = Transcript.create(params[:transcript])
    render :json => { :data => @transcript }
  end

  def embed
    @transcript = Transcript.find_by_id(params[:id])
    @lines = @transcript.lines
    @youtube_id = @transcript.video.youtube_id
    render file: 'transcripts/embed.js'
  end

  def destroy
    @transcript = Transcript.find_by_id(params[:id])
    @transcript.destroy
    if @transcript.save then render json: { data: @transcript } else render json: { data: 'save_failed' } end
  end

end
