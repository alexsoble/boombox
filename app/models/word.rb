class Word < ActiveRecord::Base
  attr_accessible :video_id, :user_id, :text
  belongs_to :video
  belongs_to :user
end
