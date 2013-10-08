class TweetsController < ApplicationController

  def create
    @tweet = Tweet.create(params[:tweet])
    if @tweet.save
      render :json => { :data => @tweet }
    else
      render :json => { :data => 'save-failed' }
    end
  end

end
