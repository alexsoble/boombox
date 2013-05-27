class Video < ActiveRecord::Base
  attr_accessible :artist, :title, :url, :lang1
  has_many :interpretations
  has_many :lines, :through => :interpretations
end
