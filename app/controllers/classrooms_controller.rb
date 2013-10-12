class ClassroomsController < ApplicationController

  def create
    @classroom = Classroom.create(params[:classroom])
    render :json => { :data => @classroom }
  end

  def show
    @classroom = Classroom.find_by_id(params[:id])
    @students = User.where(:classroom_id => @classroom.id)
    @teacher = User.find_by_id(@classroom.user_id)
  end

end
