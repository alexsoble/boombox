class ChallengesController < ApplicationController

  def create
    @challenge = Challenge.create(params[:challenge])
    render :json => { :data => @challenge }
  end

end
