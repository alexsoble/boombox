class TagVote < ActiveRecord::Base
  attr_accessible :tag_id, :user_id, :value

  belongs_to :tag
  belongs_to :user

end