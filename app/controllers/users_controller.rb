class UsersController < ApplicationController

  def new
    @user = User.new
  end 

  def index
    @top_ten_users = User.limit(10)
  end

  def show
    @user = User.find_by_id(params[:id])
    @interpretation = Interpretation.where(:user_id => @user.id).order("created_at ASC")
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
