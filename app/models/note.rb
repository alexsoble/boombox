class Note < ActiveRecord::Base
  attr_accessible :interpretation_id, :note_text, :user_id, :video_id
  belongs_to :interpretation
  belongs_to :video
  belongs_to :user
end
