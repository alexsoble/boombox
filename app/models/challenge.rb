class Challenge < ActiveRecord::Base
  attr_accessible :question_text, :user_id, :video_id
  belongs_to :user
  has_many :options
end
