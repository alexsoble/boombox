class Word < ActiveRecord::Base
  attr_accessible :video_id, :user_id, :interpretation_id, :text
  belongs_to :video
  belongs_to :interpretation
  belongs_to :user
  has_many :definitions
end
