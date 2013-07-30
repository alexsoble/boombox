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

  def show

    @quiz = Quiz.find(params[:id])
    @interp = Interpretation.find(@quiz.interpretation_id)
    @words = []

    Word.where(:quiz_id => @quiz.id).all.each do |w|
      @words << w.text
    end

    render "interpretations/show"

  end

end
