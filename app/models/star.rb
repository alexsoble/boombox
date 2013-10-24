class Star < ActiveRecord::Base
  attr_accessible :interpretation_id, :user_id, :video_id, :transcript_id, :translation_id
  belongs_to :user
  belongs_to :interpretation
  belongs_to :video
  belongs_to :translation
  belongs_to :transcript
end
