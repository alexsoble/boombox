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

    @vocabulary = Word.where(:user_id => @user.id).order("created_at DESC")
    @vocabulary_interps = []
    @vocabulary.each do |v|
      interp = Interpretation.find_by_id(v.interpretation_id)
      if @vocabulary_interps.index(interp) == nil then @vocabulary_interps << interp end
    end

    # @multiple_choice = Challenge.where(:user_id => @user.id).order("created_at DESC")
    # @multiple_choice_videos = []
    # @multiple_choice.each do |c|
    #   video = Video.find_by_id(c.video_id)
    #   if @multiple_choice_videos.index(video) == nil then @multiple_choice_videos << video end
    # end

    # @discussion_questions = DiscussionQuestion.where(:user_id => @user.id).order("created_at DESC")
    # @discussion_question_videos = []
    # @discussion_questions.each do |d|
    #   video = Video.find_by_id(d.video_id)
    #   if @discussion_question_videos.index(video) == nil then @discussion_question_videos << video end
    # end

    # @tweets = Tweet.where(:user_id => @user.id).order("created_at DESC")
    # @tweet_videos = []
    # @tweets.each do |t|
    #   video = Video.find_by_id(t.video_id)
    #   if @tweet_videos.index(video) == nil then @tweet_videos << video end
    # end

    # @links = Link.where(:user_id => @user.id).order("created_at DESC")
    # @link_videos = []
    # @links.each do |l|
    #   video = Video.find_by_id(l.video_id)
    #   if @link_videos.index(video) == nil then @link_videos << video end
    # end

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