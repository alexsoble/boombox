class ChallengesController < ApplicationController

  def create
    @challenge = Challenge.create(params[:challenge])
    render :json => { :data => @challenge }
  end

  def show
    @challenge = Challenge.find(params[:id])
    @challenger = User.find_by_id(@challenge.user_id)
    @options = Option.where(:challenge_id => @challenge.id)
  end

end
