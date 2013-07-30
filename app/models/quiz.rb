class Quiz < ActiveRecord::Base
  attr_accessible :interpretation_id, :type, :name, :description
  belongs_to :interpretation
  has_many :words
end
