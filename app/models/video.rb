class Video < ActiveRecord::Base
  attr_accessible :title, :youtube_id, :slug
  has_many :tags
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
  validates_uniqueness_of :slug, :youtube_id
  validates_presence_of :slug, :youtube_id, :title

  def generate_slug

    if self.slug.blank?
      if self.title[0..100].parameterize.present?
        if Video.where(:slug => self.title[0..100].parameterize).blank?
          self.slug = self.title[0..100].parameterize 
        else
          self.slug = self.title[0..100].parameterize + '-' + self.youtube_id.parameterize
        end
      else
        self.slug = self.youtube_id.parameterize
      end
    end

  end

  def approximate_difficulty
    difficulties = []
    self.tags.each do |t|
      if t.difficulty.present?
        difficulties << t.difficulty.id
      end
    end
    return difficulties.inject{ |sum, el| sum + el }.to_f / difficulties.size
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
