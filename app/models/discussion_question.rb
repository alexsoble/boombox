class DiscussionQuestion < ActiveRecord::Base
  attr_accessible :interpretation_id, :question_text, :user_id, :video_id
  belongs_to :interpretation
  belongs_to :user
  belongs_to :video
end
