class Line < ActiveRecord::Base
  attr_accessible :downvotes, :interpretation_id, :lang1, :lang2, :time, :upvotes, :duration
  belongs_to :interpretation
end
