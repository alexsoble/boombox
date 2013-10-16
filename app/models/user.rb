class User < ActiveRecord::Base
  has_secure_password
  has_many :interpretations
  has_many :discussion_questions
  has_many :discussion_responses
  has_many :stars
  has_many :interests
  has_many :comments
  belongs_to :school
  has_one :classroom
  belongs_to :classroom

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

  attr_accessible :email, :firstname, :lastname, :username, :password, :password_confirmation, :bio, :image_url
  
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

end