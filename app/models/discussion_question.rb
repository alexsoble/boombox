class DiscussionQuestion < ActiveRecord::Base
  attr_accessible :question_text, :user_id, :video_id
end
