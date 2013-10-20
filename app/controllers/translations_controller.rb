class TranslationsController < ApplicationController

  def create 
    @translation = Translation.create(params[:translation])
    render json: { data: @translation }
  end

  def show
    @translation = Translation.find_by_id(params[:id])
    @video = @translation.transcript.video 
  end

end
