class UsersController < ApplicationController
  respond_to :json, :html

  def show

    @user = User.find_by_id(params[:id])
    @interpretation = Interpretation.where(:user_id => @user.id).order("created_at ASC")
    @drafts = @interpretation.where(:published => false).order("created_at ASC")
    @published = @interpretation.where(:published => true).order("created_at ASC")

  end

  def new
  
  end

  def create

    @user = User.new(params[:user])
      if @user.save
      @user.firstname = params[:firstname]
      @user.lastname = params[:lastname]
      @user.save
        session[:user_id] = @user.id
        render "stepthree", :user => @user
      else
        render "steptwo"
      end
    end

  def steptwo

    if params[:school].blank? || params[:lastname].blank? || params[:firstname].blank? || params[:role].blank?
      flash[:notice] = "Please make sure you've filled out all of the fields."
      redirect_to '/join'
    else
      @firstname = params[:firstname]
      @lastname = params[:lastname]
    end

    @user = User.new
    @firstname = params[:firstname]
    @interp = params[:interp]
  end 

  def stepthree

    @user = User.find_by_id(params[:user])
    @bio = params[:bio]
    @user.bio = @bio
    @user.save
    
  end
    
end