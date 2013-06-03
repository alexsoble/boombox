class InterpretationsController < ApplicationController
  respond_to :json

  def create 
  
    @youtube_id = params[:interpretation][:youtube_id]
    @lang1 = params[:interpretation][:lang1]
    @lang2 = params[:interpretation][:lang2]
    @video = Video.where(:youtube_id => @youtube_id).first

    if @video.blank?
      # that's not good!
    elsif @video.lang1.blank?
      @video.lang1 = @lang1
    elsif @video.lang1 == @lang1
      # that's good!
    elsif @video.lang1 != @lang1
      # that's not good!
    end

    @interp = Interpretation.create(:video_id => @video.id, :lang2 => @lang2)

    render :json => { :data => @interp }

    end

end
