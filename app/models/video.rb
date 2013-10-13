class Video < ActiveRecord::Base
  attr_accessible :title, :youtube_id
  has_many :interpretations
  has_many :lines, :through => :interpretations

  def to_param
    "#{title[0..30]}".parameterize
  end

  def number_of_interpretations
    Interpretation.where(:video_id => self.id).length
  end

  validates_presence_of :title, :youtube_id

end
