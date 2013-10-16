class Interest < ActiveRecord::Base
  attr_accessible :language_id, :level, :teach, :user_id
  belongs_to :user
  belongs_to :language
end
