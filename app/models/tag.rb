class Tag < ActiveRecord::Base
  attr_accessible :name, :type_artist, :type_difficulty, :type_lang, :type_style, :user_id, :video_id
end
