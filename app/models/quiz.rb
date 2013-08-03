class Quiz < ActiveRecord::Base
  attr_accessible :interpretation_id, :user_id, :quiz_type, :name, :description
  belongs_to :interpretation
  belongs_to :user
  has_many :words
end
