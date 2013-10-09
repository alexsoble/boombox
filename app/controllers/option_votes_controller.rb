class OptionVotesController < ApplicationController

  def create
    @option_vote = OptionVote.create(params[:option_vote])
    render :json => { :option_vote => @option_vote }
  end

end
