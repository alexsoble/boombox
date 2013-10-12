class Challenge < ActiveRecord::Base
  attr_accessible :interpretation_id, :question_text, :user_id, :video_id
  belongs_to :interpretation
  belongs_to :video
  belongs_to :user
  has_many :options
end
