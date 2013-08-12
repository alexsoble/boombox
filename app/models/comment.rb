class Comment < ActiveRecord::Base
  attr_accessible :comment_text, :line_id, :user_id
  belongs_to :user
  belongs_to :line
end
