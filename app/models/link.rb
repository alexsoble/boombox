class Link < ActiveRecord::Base
  attr_accessible :excerpt, :language_id, :url, :user_id, :video_id
end
