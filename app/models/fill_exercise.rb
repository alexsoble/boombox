class FillExercise < ActiveRecord::Base
  attr_accessible :transcript_id, :user_id, :video_id
  belongs_to :transcript
  belongs_to :user
  belongs_to :video
  has_many :missing_words
  before_validation :generate_slug
  validates_uniqueness_of :slug
  validates_presence_of :slug

  def generate_slug
    if self.slug.blank?
      self.slug = "#{self.user.username.parameterize}-#{self.video.slug}-#{self.id}"
    end
  end

  def to_param
    slug
  end

end