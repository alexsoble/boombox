class Translation < ActiveRecord::Base
  attr_accessible :transcript_id, :video_id, :user_id, :language_id
end
