class TagVotesController < ApplicationController

  def create
    @tag_vote = TagVote.create(params[:tag_vote])
    render :json => { :tag_vote => @tag_vote }
  end

  def update
    @tag_vote = TagVote.where(:id => params[:vote_id].to_i, :user_id => params[:user_id].to_i).first
    logger.debug("TAG VOTE=#{@tag_vote}")
    new_value = params[:value]
    @tag_vote.value = new_value
    if @tag_vote.save
      render :json => { :tag_vote => @tag_vote }
    else
      render :json => { :tag_vote => 'update-failed' }
    end
  end

end
  