class Definition < ActiveRecord::Base
  attr_accessible :text, :user_id, :word_id
  belongs_to :user
  belongs_to :word
end