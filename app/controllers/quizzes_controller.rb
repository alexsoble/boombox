class QuizzesController < ApplicationController

  def create
    @quiz = Quiz.create(params[:quiz])
    render :json => { :data => @quiz }
  end

  def update

  end

end
