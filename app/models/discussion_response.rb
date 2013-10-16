class DiscussionResponse < ActiveRecord::Base
  attr_accessible :discussion_question_id, :response_text, :user_id
  belongs_to :user
end
