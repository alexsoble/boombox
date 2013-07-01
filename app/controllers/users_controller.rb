class UsersController < ApplicationController

  def show
    @user = User.find_by_id(params[:id])
    @interpretation = Interpretation.where(:user_id => @user.id).order("created_at ASC")
    @drafts = @interpretation.where(:published => false).order("created_at ASC")
    @published = @interpretation.where(:published => true).order("created_at ASC")
  end

  def new
    @user = User.new
    @interp = params[:interp]
  end 

  def index
    @top_ten_users = User.limit(10)
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      if params['data-interp'].blank?
        redirect_to root_url, :notice => "Signed up!"
      else
        @interp = Interpretation.find_by_id(params['data-interp'])
        @interp.user_id = @user.id
        @interp.save
        redirect_to interpretation_url(@interp)
      end
    else
      render "new"
    end
  end
  
end