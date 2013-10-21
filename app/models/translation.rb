class Translation < ActiveRecord::Base
  attr_accessible :transcript_id, :video_id, :user_id, :language_id
  belongs_to :transcript
  belongs_to :user
  belongs_to :video
  belongs_to :language
  has_many :translated_lines
  before_validation :generate_slug
  validates_uniqueness_of :slug
  validates_presence_of :slug, :user, :video, :transcript

  def generate_slug
    if self.slug.blank?
      if Translation.where(:slug => "#{self.user.username.parameterize}-#{self.video.slug}").blank?
        self.slug = "#{self.user.username.parameterize}-#{self.video.slug}"
      else
        self.slug = "#{self.user.username.parameterize}-#{self.video.slug}-#{self.id}"
      end
    end
  end

  def to_param
    slug
  end

end