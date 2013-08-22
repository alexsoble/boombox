class Interpretation < ActiveRecord::Base
  attr_accessible :lang2, :video_id, :user_id, :published, :note
  belongs_to :video
  belongs_to :user
  has_many :clips
  has_many :quizzes

  def video
    Video.find_by_id(self.video_id)
  end

  def lang1
    if self.video.present?
      self.video.lang1
    else 
      ''
    end
  end

end
