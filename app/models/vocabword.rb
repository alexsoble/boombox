class Vocabword < ActiveRecord::Base
  attr_accessible :definition, :interpretation_id, :user_id, :word_text
end
