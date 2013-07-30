class Quiz < ActiveRecord::Base
  attr_accessible :interpretation_id, :type
  belongs_to :interpretation
  has_many :words
end
