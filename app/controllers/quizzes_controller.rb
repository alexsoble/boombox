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

    @title = @interp.video.title
    @lines = Line.where(:interpretation_id => @interp.id).order("created_at ASC")
    @url = request.url

    @video = @interp.video
    @lang2 = @interp.lang2
    @lang1 = @video.lang1
    @published = @interp.published

    @words = []

    Word.where(:quiz_id => @quiz.id).all.each do |w|
      @words << w.text
    end

    if @interp.user_id == 0
      @user = 'anon' 
    else
      @user = User.find_by_id(@interp.user_id)
    end

    render "interpretations/show"

  end

end
