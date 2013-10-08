class DefinitionVotesController < ApplicationController

  def create
    @definition_vote = DefinitionVote.create(params[:definition_vote])
    render :json => { :definition_vote => @definition_vote }
  end

  def update
    @definition_vote = DefinitionVote.where(:id => params[:vote_id].to_i, :user_id => params[:user_id].to_i).first
    logger.debug("DEFINITION VOTE=#{@definition_vote}")
    new_value = params[:value]
    @definition_vote.value = new_value
    if @definition_vote.save
      render :json => { :definition_vote => @definition_vote }
    else
      render :json => { :definition_vote => 'update-failed' }
    end
  end

end
