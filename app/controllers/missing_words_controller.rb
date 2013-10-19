class MissingWordsController < ApplicationController

  def create
    @missing_word = MissingWord.create(params[:missing_word])
    render :json => { :data => @missing_word }
  end

end
