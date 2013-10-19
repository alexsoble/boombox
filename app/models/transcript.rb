class Transcript < ActiveRecord::Base
  attr_accessible :interpretation_id, :user_id, :video_id
  belongs_to :interpretation
  belongs_to :user
  belongs_to :video
  has_many :lines
end
