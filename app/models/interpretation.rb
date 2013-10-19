class Interpretation < ActiveRecord::Base
  attr_accessible :lang2, :video_id, :user_id, :published, :note
  belongs_to :video
  belongs_to :user
  belongs_to :language
  has_many :transcripts
  has_many :words
  has_many :challenges
  has_many :discussion_questions
  has_many :lines
  has_many :links
  has_many :tweets
  has_many :clips
  has_many :quizzes
  has_many :stars

  def video
    return Video.find_by_id(self.video_id)
  end

end
