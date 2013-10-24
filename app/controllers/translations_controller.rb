class TranslationsController < ApplicationController

  def create 
    @translation = Translation.create(params[:translation])
    render json: { data: @translation }
  end

  def show
    @translation = Translation.find_by_slug!(params[:id])
    @video = @translation.transcript.video 
    @user = @translation.user 
  end

  def find
    @translation = Translation.find_by_id(params[:id])
    render json: { data: @translation }
  end

  def destroy
    @translation = Translation.find_by_id(params[:id])
    @translation.destroy
    if @translation.save
      render json: { data: @translation } 
    else 
      render json: { data: 'save_failed' }
    end
  end

end
