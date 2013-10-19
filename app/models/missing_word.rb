class MissingWord < ActiveRecord::Base
  attr_accessible :fill_exercise_id, :word_text, :line_id
  belongs_to :fill_exercise
  belongs_to :line
end
