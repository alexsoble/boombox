class Transcript < ActiveRecord::Base
  attr_accessible :interpretation_id, :user_id, :video_id
  belongs_to :interpretation
  belongs_to :user
  belongs_to :video
  has_many :lines
  has_many :translations
  before_validation :generate_slug
  validates_uniqueness_of :slug
  validates_presence_of :slug, :user, :video

  def generate_slug
      if Transcript.where(:slug => "#{self.video.slug}-lyrics").blank?
        self.slug = "#{self.video.slug}-lyrics"
      else
        @last = Transcript.last
        self.slug = "#{self.video.slug}-lyrics-#{self.id}"
      end
  end

  def to_param
    slug
  end

end