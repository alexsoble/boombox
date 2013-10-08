class Tweet < ActiveRecord::Base
  attr_accessible :twitter_id, :tweeter, :user_id, :video_id
end
