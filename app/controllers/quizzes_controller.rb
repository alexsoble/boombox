class QuizzesController < ApplicationController
  respond_to :json, :html

  def create
    @quiz = Quiz.create(params[:quiz])
    render :json => { :data => @quiz }
  end

  def save_words

    @quiz = Quiz.find(params[:quiz_id])
    @words = JSON.parse(params[:words])

    @words.each do |w|
      Word.create(w)
    end

  end

end
