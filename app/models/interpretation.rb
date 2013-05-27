class Interpretation < ActiveRecord::Base
  attr_accessible :lang2, :video_id
  belongs_to :video
end
