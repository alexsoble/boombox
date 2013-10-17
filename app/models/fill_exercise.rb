class FillExercise < ActiveRecord::Base
  attr_accessible :transcript_id, :user_id, :video_id
  belongs_to :interpretation
  belongs_to :user
  belongs_to :video
end
