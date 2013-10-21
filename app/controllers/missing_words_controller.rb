class MissingWordsController < ApplicationController

  def create
    @missing_word = MissingWord.create(params[:missing_word])
    render :json => { :data => @missing_word }
  end

  def destroy
    @missing_word = MissingWord.find_by_id(params[:id])
    @missing_word.destroy
    if @missing_word.save then render json: { data: @missing_word } else render json: { data: 'save_failed' } end
  end

end
