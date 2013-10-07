class TagsController < ApplicationController

  def create
    @tag = Tag.new
    @tag.name = params[:name]
    @tag.video_id = params[:video_id]
    @tag.user_id = params[:user_id]

    @tag.type_lang = false
    @tag.type_style = false
    @tag.type_artist = false
    @tag.type_difficulty = false

    tag_type = params[:tag_type]
    if tag_type == 'language'
      @tag.type_lang = true
    elsif tag_type == 'style'
      @tag.type_style = true
    elsif tag_type == 'artist'
      @tag.type_artist = true
    elsif tag_type == 'difficulty'
      @tag.type_difficulty = true
    end

    @tag.save

    render :json => { :tag => @tag }
  end

  def show

    @tag = Tag.find_by_id(params[:id])
    @tag_creator = User.find_by_id(@tag.user_id)
    @tag_video = Video.find_by_id(@tag.video_id)

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

    @votes = TagVote.where(:tag_id => @tag.id)
    @upvote_total = @votes.where(:value => 1).length
    @downvote_total = @votes.where(:value => -1).length

  end

  def destroy

    @tag = Tag.find_by_id(params[:id])
    @tag_video = Video.find_by_id(@tag.video_id)
    @tag.destroy
    @tag.save
    redirect_to video_url(@tag_video)
    
  end

end