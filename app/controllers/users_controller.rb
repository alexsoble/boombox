class UsersController < ApplicationController
  respond_to :json, :html

  def show

    @user = User.find_by_id(params[:id])
    @bio = @user.bio
    @firstname = @user.firstname
    @lastname = @user.lastname
    
    @interpretation = Interpretation.where(:user_id => @user.id).order("created_at ASC")
    @drafts = @interpretation.where(:published => false).order("created_at ASC")
    @published = @interpretation.where(:published => true).order("created_at ASC")

  end

  def new

    @user = User.new
  
  end

  def create

    @user = User.create(params[:user])
    @schools = School.all
    if @user.save
      session[:user_id] = @user.id
      redirect_to "/steptwo?user=#{@user.id}"
    else
      render "new"
    end

  end

  def steptwo

    @schools = School.all
    @user = User.find_by_id(params[:user])
    @firstname = @user.firstname

  end

  def update

    @user = User.find_by_id(params[:user])
    if params[:bio].present?
      @user.bio = params[:bio]
      @user.save
    end
    
    if params[:school].present?
      @school = School.where(:name => params[:school]).first
      @user.school_id = @school.id
      @user.save
    end

  end

end