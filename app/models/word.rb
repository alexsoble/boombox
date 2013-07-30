class Word < ActiveRecord::Base
  attr_accessible :quiz_id, :text
  belongs_to :quiz
end
