class InterpretationsController < ApplicationController
  respond_to :json

  def create 
  
    @youtube_id = params[:interpretation][:youtube_id]
    @video = Video.where(:youtube_id => @youtube_id)

    if @video.blank?
      # that's not good!
    end

    @interp = Interpretation.new(:video_id => @video.id)

      if @interp.save
        data = "Saved."
      else
        data = "Failed."
      end

      respond_with data

    end

end
