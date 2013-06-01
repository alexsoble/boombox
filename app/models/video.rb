class Video < ActiveRecord::Base
  attr_accessible :title, :youtube_id, :lang1
  has_many :interpretations
  has_many :lines, :through => :interpretations
end
