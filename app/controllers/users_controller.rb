class UsersController < ApplicationController

  def join
    @user = User.new
  end 

  def index
    @top_ten_users = User.limit(10)
  end

  def show
    @interpretations = interpretation.where(:user_id => @current_user.id).order("created_at ASC")

  end

  def new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
  
end
