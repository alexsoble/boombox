class Interpretation < ActiveRecord::Base
  attr_accessible :lang2, :video_id, :user_id, :published
  belongs_to :video
  belongs_to :user

  def video
    Video.find_by_id(self.video_id) || ''
  end

  def lang1
    Video.find_by_id(self.video_id).lang1 || ''
  end

end
