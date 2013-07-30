class Quiz < ActiveRecord::Base
  attr_accessible :interpretation_id, :quiz_type, :name, :description
  belongs_to :interpretation
  has_many :words
end
