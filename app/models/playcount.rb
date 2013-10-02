class Playcount < ActiveRecord::Base
  attr_accessible :play_count, :user_id, :video_id
end
