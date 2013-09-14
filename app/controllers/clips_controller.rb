class ClipsController < ApplicationController
  respond_to :json, :html

  def show

    @clip = Clip.find_by_id(params[:id])
    @start = @clip.start
    @duration = @clip.duration

    @interp = Interpretation.find_by_id(@clip.interpretation_id)
    @video = @interp.video
    @translator = User.find_by_id(@interp.user_id)

    @keywords = []
    Keyword.where(:interpretation_id => @interp.id).each do |k|
      @keywords << k.word_text
    end

    @lines = Line.where(interpretation_id: @interp.id).order("time ASC")
    @lines_within_clip = @lines.where(time: @start .. @start + @duration)
    @first_line = @lines_within_clip.first
    
    @lang2 = @interp.lang2
    @lang1 = @video.lang1
    @published = @interp.published
    @clip = true

    render template: 'interpretations/show'

  end

  def create

    @clip = Clip.create(params[:clip])
    render :json => { :data => @clip }

  end
  
end