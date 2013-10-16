class DiscussionResponsesController < ApplicationController

  def create
    @discussion_response = DiscussionResponse.create(params[:discussion_response])
    render :json => { :data => @discussion_response }
  end

end
