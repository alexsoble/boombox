class DefinitionsController < ApplicationController

  def create
    @definition = Definition.create(params[:definition])
    render :json => { :data => @definition }
  end

  def show

    @definition = Definition.find_by_id(params[:id])
    @word = Word.find_by_id(@definition.word_id)
    @definition_creator = User.find_by_id(@word.user_id)
    @definition_video = Video.find_by_id(@word.video_id)

    if current_user
      @user_vote = DefinitionVote.where(:user_id => current_user.id, :definition_id => @definition.id).first
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

    @votes = DefinitionVote.where(:definition_id => @definition.id)
    @upvote_total = @votes.where(:value => 1).length
    @downvote_total = @votes.where(:value => -1).length

  end

  def destroy

    @definition = Definition.find_by_id(params[:id])
    @word = Word.find_by_id(@definition.word_id)
    @definition_video = Video.find_by_id(@word.video_id)
    @definition.destroy
    @definition.save
    @word.destroy
    @word.save
    redirect_to video_url(@definition_video)

  end

end
