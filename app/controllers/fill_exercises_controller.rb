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
    render :json => { :data_lines => @lines, :data_missing_words => @missing_words, :data => @fill_exercise }
  end

  def show
    @fill_exercise = FillExercise.find_by_slug!(params[:id])
    @transcript = @fill_exercise.transcript
    @lines = @transcript.lines.sort { |a, b| a.time <=> b.time }
    @missing_words = @fill_exercise.missing_words
    @user = @fill_exercise.user
    @video = @fill_exercise.video
  end 

  def destroy
    @fill_exercise = FillExercise.find_by_id(params[:id])
    @fill_exercise.destroy
    if @fill_exercise.save then render json: { data: @fill_exercise } else render json: { data: 'save_failed' } end
  end

end
