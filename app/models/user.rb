class User < ActiveRecord::Base
  has_secure_password
  has_many :interpretations
  has_many :translations
  has_many :transcripts
  has_many :discussion_questions
  has_many :discussion_responses
  has_many :fill_exercises
  has_many :stars
  has_many :interests
  has_many :comments
  has_many :definitions
  has_many :words
  belongs_to :school
  has_one :classroom
  belongs_to :classroom
  before_validation :generate_slug
  validates_presence_of :slug, :username, :email
  validates_uniqueness_of :slug, :username, :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  attr_accessible :email, :firstname, :lastname, :username, :password, :password_confirmation, :bio, :image_url

  def generate_slug
    if self.slug.blank?
      if self.username.parameterize.present?
        self.slug = "#{self.username.parameterize}"
      end
    end
  end

  def to_param
    slug
  end

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

end