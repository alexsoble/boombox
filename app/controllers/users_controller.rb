class UsersController < ApplicationController
  respond_to :json, :html

  def list
    term = params[:term]
    term_length = term.length

    @users = []
    User.all.each do |u|
      if u.username[0..(term_length - 1)].upcase == term.upcase
        @users << u
      elsif u.firstname.present?
        if u.firstname[0..(term_length - 1)].upcase == term.upcase
          @users << u
        end
      elsif u.lastname.present?
        if u.lastname[0..(term_length - 1)].upcase == term.upcase
          @users << u
        end
      end
    end
    render json: { :data => @users }
  end

  def show
    @user = User.find_by_id(params[:id])
    @bio = @user.bio
    @username = @user.username
    @firstname = @user.firstname
    @lastname = @user.lastname
    @user_school = School.where(:id => @user.school_id).first
    @user_role = @user.teacher
    @schools = School.all

    @interpretations = Interpretation.where(:user_id => @user.id).all

    @stars = Star.where(:user_id => @user.id).all
    @starred = []
    @stars.each do |s|
      video = Video.find_by_id(s.video_id)
      if @starred.index(video) == nil then @starred << video end
    end

  end

  def teacher_dashboard
    @user = User.find_by_id(params[:id])
    @classes = Classroom.where(:user_id => @user.id)
  end

  def new

    @user = User.new

    if params[:interp].present?
      @interp = params[:interp]
    else
      @interp = nil
    end
  
  end

  def create

    @user = User.create(params[:user])
    @schools = School.all
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_url(@user)
    else
      render "new"
    end

  end

  def update

    @user = User.find_by_id(params[:user_id])

    if params[:firstname].present?
      @user.firstname = params[:firstname]
      @user.save
    end
    if params[:lastname].present?
      @user.lastname = params[:lastname]
      @user.save
    end
    if params[:bio].present?
      @user.bio = params[:bio]
      @user.save
    end
    if params[:school].present?
      @school = School.where(:name => params[:school]).first
      @user.school_id = @school.id
      @user.save
    end

    render :json => { :data => @user }

  end

end