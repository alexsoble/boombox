class Definition < ActiveRecord::Base
  attr_accessible :text, :user_id, :word_id
  belongs_to :user
  belongs_to :word
  before_validation :generate_slug
  validates_presence_of :slug, :user, :word
  validates_uniqueness_of :slug

  def generate_slug
    if self.slug.blank?
      self.slug = "#{self.word.text}-#{self.text}-user-#{self.user.username}".parameterize
    end
  end

  def to_param
    slug
  end

end