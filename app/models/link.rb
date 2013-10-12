class Link < ActiveRecord::Base
  attr_accessible :interpretation_id, :excerpt, :language_id, :url, :user_id, :video_id
  belongs_to :interpretation
  belongs_to :video
  belongs_to :user
end
