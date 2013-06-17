class UsersController < ApplicationController

  def show
    @user = User.find_by_id(params[:id])
    @interpretation = Interpretation.where(:user_id => @user.id).order("created_at ASC")
    @drafts = @interpretation.where(:published => false).order("created_at ASC")
    @published = @interpretation.where(:published => true).order("created_at ASC")
  end

  def new
    @user = User.new
  end 

  def index
    @top_ten_users = User.limit(10)
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