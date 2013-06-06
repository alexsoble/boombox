class Interpretation < ActiveRecord::Base
  attr_accessible :lang2, :video_id, :user_id
  belongs_to :video
  belongs_to :user
end
