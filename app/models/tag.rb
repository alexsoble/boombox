class Tag < ActiveRecord::Base
  attr_accessible :language_id, :video_id, :user_id, :difficulty_id
  belongs_to :user
  belongs_to :language
  belongs_to :video
  belongs_to :difficulty
  has_many :tag_votes
end
