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
    @firstname = @user.firstname
    @lastname = @user.lastname
    
    @interpretation = Interpretation.where(:user_id => @user.id).order("created_at ASC")
    @drafts = @interpretation.where(:published => false).order("created_at ASC")
    @published = @interpretation.where(:published => true).order("created_at ASC")

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

    if params[:interp].present?
      @interp = Interpretation.find_by_id(params[:interp])
    end

    @schools = School.all
    if @user.save
      session[:user_id] = @user.id
      if @interp.present?
        if @interp.user_id == 0
          @interp.user_id = @user.id
          @interp.save
          redirect_to interpretation_url(@interp)
          return 
        end 
      else
        redirect_to "/steptwo?user=#{@user.id}"
      end
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