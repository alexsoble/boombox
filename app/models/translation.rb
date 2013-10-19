class Translation < ActiveRecord::Base
  attr_accessible :transcript_id, :video_id, :user_id, :language_id
  belongs_to :transcript
  belongs_to :user
  belongs_to :language
  has_many :translated_lines
end
