class FillExercisesController < ApplicationController

  def create
    @fill_exercise = FillExercise.create(params[:fill_exercise])
    render :json => { :data => @fill_exercise }
  end

  def find
    @fill_exercise = FillExercise.find_by_id(params[:fill_exercise_id])
    @transcript = @fill_exercise.transcript
    @lines = @transcript.lines.order("created_at ASC").order("time ASC")
    @missing_words = @fill_exercise.missing_words
    render :json => { :data_lines => @lines, :data_missing_words => @missing_words }
  end

  def show
    @fill_exercise = FillExercise.find_by_id(params[:id])
    @transcript = @fill_exercise.transcript
    @lines = @transcript.lines
    @missing_words = @fill_exercise.missing_words
    @user = @fill_exercise.user
    @video = @fill_exercise.video
  end 

end
