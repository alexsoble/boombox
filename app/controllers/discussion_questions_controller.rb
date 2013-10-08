class DiscussionQuestionsController < ApplicationController
  
  def create
    @discussion_question = DiscussionQuestion.create(params[:discussion_question])
    render :json => { :data => @discussion_question }
  end


end
