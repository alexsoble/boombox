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

    if current_user
      if Star.where(:video_id => @video.id, :user_id => current_user.id).present?
        @star = Star.where(:video_id => @video.id, :user_id => current_user.id).first
      end
    end

    @tags = Tag.where(:video_id => @video.id)

    if @tags.present?
      @lang_tags = @tags.where(:type_lang => true)
      @last_lang_tag = @lang_tags[@lang_tags.length - 1]

      @artist_tags = @tags.where(:type_artist => true)
      @last_artist_tag = @artist_tags[@artist_tags.length - 1]

      @difficulty_tags = @tags.where(:type_difficulty => true)
      @last_difficulty_tag = @difficulty_tags[@difficulty_tags.length - 1]

      @style_tags = @tags.where(:type_style => true)
      @last_style_tag = @style_tags[@style_tags.length - 1]
    end 

    @last_tag = @tags[@tags.length - 1]

    if @tags.length < 2
      @all_but_last_tag = []
    else
      @all_but_last_tag = @tags[0..(@tags.length - 1)]
    end

    @transcripts = @video.transcripts

    @translations = []
    @transcripts.each do |t|
      if t.translations.present?
        @translation = true
        t.translations.each do |tr|
          @translations << tr
        end
      end
    end

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

  def find_slug
    @video = Video.find_by_id(params[:id])
    @slug = @video.slug
    render json: { data: @slug } 
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
