class Video < ActiveRecord::Base
  attr_accessible :title, :youtube_id, :lang1
  has_many :interpretations
  has_many :lines, :through => :interpretations

  def number_of_requests
    Request.where(:video_id => self.id).length
  end

  def number_of_interpretations
    Interpretation.where(:video_id => self.id).length
  end

  validates_presence_of :title, :youtube_id, :lang1

end
