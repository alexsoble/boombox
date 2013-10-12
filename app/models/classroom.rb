class Classroom < ActiveRecord::Base
  attr_accessible :name, :user_id
  has_many :users
  belongs_to :user
end
