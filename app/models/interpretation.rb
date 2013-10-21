class Interpretation < ActiveRecord::Base
  attr_accessible :lang2, :video_id, :user_id
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
  before_validation :generate_slug
  validates_uniqueness_of :slug
  validates_presence_of :slug, :user, :video

  def generate_slug
    if self.slug.blank?
      if Interpretation.where(:slug => "#{self.user.username.parameterize}-#{self.video.slug}").blank?
        self.slug = "#{self.user.username.parameterize}-#{self.video.slug}"
      else
        @last = Interpretation.last
        self.slug = "#{self.user.username.parameterize}-#{self.video.slug}-#{@last.id + 1}"
      end
    end
  end

  def to_param
    slug
  end

  def video
    return Video.find_by_id(self.video_id)
  end

end
