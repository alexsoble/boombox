class FillExercise < ActiveRecord::Base
  attr_accessible :transcript_id, :user_id, :video_id
  belongs_to :transcript
  belongs_to :user
  belongs_to :video
  has_many :missing_words
end
