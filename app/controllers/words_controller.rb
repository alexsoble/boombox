class WordsController < ApplicationController

  def create
    @word = Word.create(params[:word])
    render :json => { :data => @word }
  end

  def update_time

  end

end
