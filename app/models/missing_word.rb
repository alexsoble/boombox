class MissingWord < ActiveRecord::Base
  attr_accessible :fill_exercise_id, :word_text
  belongs_to :fill_exercise
end
