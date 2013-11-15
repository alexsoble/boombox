class TagsController < ApplicationController

  def create
    @tag = Tag.create(params[:tag])
    render json: { data: @tag }
  end

  def update
    @tag = Tag.find_by_id(params[:tag][:id])
    if params[:tag][:difficulty_id].present?
      @tag.difficulty_id = params[:tag][:difficulty_id]
    end
    if params[:tag][:reason].present?
      @tag.reason = params[:tag][:reason]
    end
    if @tag.save
      render json: { data: @tag }
    end
  end

  def show

    @tag = Tag.find_by_id(params[:id])
    @tag_creator = User.find_by_id(@tag.user_id)
    @tag_video = Video.find_by_id(@tag.video_id)

    if @tag.language.present?
      @language = @tag.language.name
    end

    if @tag.difficulty.present?
      @difficulty = @tag.difficulty.name
    end

    if @tag.reason.present?
      @reason = @tag.reason.text
    end

    if current_user
      @user_vote = TagVote.where(:user_id => current_user.id, :tag_id => @tag.id).first
      if @user_vote.present?
        @user_vote_value = @user_vote.value
        @user_vote_id = @user_vote.id
      else
        @user_vote_value = 'no-vote'
      end
    else
      @user_vote_value = 'no-vote'
    end
    logger.debug("USER VOTE VALUE #{@user_vote_value}")

    @votes = TagVote.where(:tag_id => @tag.id)
    @upvote_total = @votes.where(:value => 1).length
    @downvote_total = @votes.where(:value => -1).length

  end

  def fetch
    @video = Video.find_by_id(params[:video_id])
    @tags = @video.tags
    render json: { data: @tags }
  end

  def destroy

    @tag = Tag.find_by_id(params[:id])
    @tag_video = Video.find_by_id(@tag.video_id)
    @tag.destroy
    @tag.save
    redirect_to video_url(@tag_video)
    
  end

end