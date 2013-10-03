class WordsController < ApplicationController

  def create
    @word = Word.create(params[:word])
    render :json => { :data => @word }
  end

  def update_time
    @word = Word.find_by_id(params[:word_id])
    @word.time = params[:time]
    @word.save
    render :json => { :data => @word }
  end

end
