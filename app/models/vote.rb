class Vote < ActiveRecord::Base
  attr_accessible :direction, :user_id, :interpretation_id
end