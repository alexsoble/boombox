class DiscussionQuestionsController < ApplicationController
  
  def create
    @discussion_question = DiscussionQuestion.create(params[:discussion_question])
    render :json => { :data => @discussion_question }
  end

  def show
    @discussion_question = DiscussionQuestion.find(params[:id])
    @question_asker = User.find_by_id(@discussion_question.user_id)
    @responses = DiscussionResponse.where(:discussion_question_id => @discussion_question.id)
  end

end
