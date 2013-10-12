class Tweet < ActiveRecord::Base
  attr_accessible :interpretation_id, :twitter_id, :tweeter, :user_id, :video_id
  belongs_to :interpretation
  belongs_to :video
  belongs_to :user
end
