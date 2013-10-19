class Video < ActiveRecord::Base
  attr_accessible :title, :youtube_id, :slug
  has_many :interpretations
  has_many :transcripts
  has_many :translations
  has_many :lines
  has_many :stars
  has_many :fill_exercises
  has_many :words
  has_many :challenges
  has_many :discussion_questions
  has_many :links
  has_many :tweets
  before_validation :generate_slug
  validates :slug, uniqueness: true, presence: true
  validates_presence_of :title, :youtube_id

  def generate_slug

    if self.slug.present?
      self.slug
    elsif self.title[0..100].parameterize.present?
      if Video.where(:slug => self.title[0..100].parameterize).blank?
        self.title[0..100].parameterize 
      else 
        self.youtube_id.parameterize
      end
    else
      self.youtube_id.parameterize
    end

  end

  def to_param
    slug
  end

  def langs
    @all_language_tags = Tag.where(:video_id => self.id, :type_lang => true)
    @language_tags = []
    @all_language_tags.each { |tag| if @language_tags.index(tag.name) == nil then @language_tags << tag.name end }
    return @language_tags
  end

  def image
    "http://img.youtube.com/vi/#{self.youtube_id}/1.jpg"
  end

  def number_of_interpretations
    Interpretation.where(:video_id => self.id).length
  end

end
