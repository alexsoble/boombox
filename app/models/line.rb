class Line < ActiveRecord::Base
  attr_accessible :downvotes, :interpretation_id, :lang1, :lang2, :time, :upvotes
  belongs_to :interpretation
end
