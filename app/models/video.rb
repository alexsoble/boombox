class Video < ActiveRecord::Base
  attr_accessible :title, :youtube_id, :slug
  has_many :interpretations
  has_many :lines, :through => :interpretations
  has_many :stars
  validates :slug, uniqueness: true, presence: true
  validates_presence_of :title, :youtube_id
  before_validation :generate_slug

  def generate_slug
    self.slug ||= self.title[0..100].parameterize
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
