class CompletedExercisesController < ApplicationController

  def create
    @completed_exercise = CompletedExercise.create(params[:completed_exercise])
    render :json => { :data => @completed_exercise }
  end

end
