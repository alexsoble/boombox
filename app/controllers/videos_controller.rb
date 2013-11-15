class VideosController < ApplicationController
  require 'json'
  respond_to :html, :json

  def create

    @youtube_id = params[:video][:youtube_id]
    if Video.where(:youtube_id => @youtube_id).blank? 
      @video = Video.create(params[:video])
    else
      @video = Video.where(:youtube_id => @youtube_id).first
    end

    render :json => { :video => @video }

  end

  def show 

    @video = Video.find_by_slug!(params[:id])
    @interps = @video.interpretations

    if current_user
      if Star.where(:video_id => @video.id, :user_id => current_user.id).present?
        @star = Star.where(:video_id => @video.id, :user_id => current_user.id).first
      end
      @this_user_interp = Interpretation.where(:video_id => @video.id, :user_id => current_user.id).first
    end

    @tags = @video.tags

    if @tags.present?
      language_votes, difficulty_votes, language_count, difficulty_count = [], [], Hash.new(0), Hash.new(0)

      @tags.each do |t|
        if t.language.present?
          language_votes << t.language
        end
        if t.difficulty.present?
          difficulty_votes << t.difficulty
        end
      end

      if language_votes.present?
        language_votes.each { |language| language_count[language] += 1 }
      end

      if language_count.present?
        @language = language_count.max_by{ |k, v| v }[0]
      end
      
      if difficulty_votes.present?
        difficulty_votes.each { |difficulty| difficulty_count[difficulty] += 1 }
      end

      if difficulty_count.present?
        @difficulty = difficulty_count.max_by{ |k, v| v }[0]
      end

      @video_description_text = @language.name

      if @difficulty.present?
        @video_description_text += " // #{@difficulty.name}"
      end

    end

    @transcripts = @video.transcripts
    @translations = []
    @transcripts.each do |t|
      if t.translations.present?
        translations = t.translations.reject { |tr| tr.translated_lines.blank? }
        translations.each do |tr|
          @translations << tr
        end
      end
    end
    @transcripts = @transcripts.reject { |tr| tr.lines.blank? }

    @lines = true
    @translation = true

    @vocabulary = Word.where(:video_id => @video.id).order("created_at DESC")
    @vocabulary_contributors = []
    @vocabulary.each { |v| if v.user.present? then if @vocabulary_contributors.index(v.user) == nil then @vocabulary_contributors << v.user end end }

    @multiple_choice = Challenge.where(:video_id => @video.id).order("created_at DESC")
    @challenge_contributors = []
    @multiple_choice.each { |c| if c.user.present? then if @challenge_contributors.index(c.user) == nil then @challenge_contributors << c.user end end }

    @fill_exercises = @video.fill_exercises

    @discussion_questions = DiscussionQuestion.where(:video_id => @video.id).order("created_at DESC")
    @question_contributors = []
    @discussion_questions.each do |t|
      user = User.where(:id => t.user_id).first
      if @question_contributors.index(user) == nil then @question_contributors << user end
    end

    @tweets = Tweet.where(:video_id => @video.id).order("created_at DESC")
    @tweet_contributors = []
    @tweets.each do |t|
      user = User.where(:id => t.user_id).first
      if @tweet_contributors.index(user) == nil then @tweet_contributors << user end
    end

    @links = Link.where(:video_id => @video.id).order("created_at DESC")
    @link_contributors = []
    @links.each do |l|
      user = User.where(:id => l.user_id).first
      if @link_contributors.index(user) == nil then @link_contributors << user end
    end

    if current_user
      if Playcount.where(:user_id => current_user.id, :video_id => @video.id).present?
        @current_user_play_count = Playcount.where(:user_id => current_user.id, :video_id => @video.id).first.play_count
      end
      if Interpretation.where(:user_id => current_user.id, :video_id => @video.id).present?
        @current_user_interp = Interpretation.where(:user_id => current_user.id, :video_id => @video.id).first
      end
    end
      
  end 

  def find
    @video = Video.find_by_id(params[:id])
    render json: { data: @video } 
  end

  def fetch
    language = Language.find_by_name(params[:term])
    tags = language.tags
    @videos = []
    tags.each { |t| @videos << t.video }
    render json: { data: @videos } 
  end

  def find_difficulty
    @video = Video.find_by_id(params[:id])
    render json: { data: @video.approximate_difficulty } 
  end

  def new

    @interp = Interpretation.find_by_id(params[:interp])
    @video = @interp.video
    @translator = User.find_by_id(@interp.user_id)
    @url = request.url
    @lang2 = @interp.lang2
    @lang1 = @video.lang1
    @published = @interp.published
    @lines = Line.where(:interpretation_id => @interp.id).order("created_at ASC")
    @lines.each do |l|
      if l.lang1.present? then @lang1_and_lang2 = true end
    end

    render "interpretations/show"
    
  end

end
