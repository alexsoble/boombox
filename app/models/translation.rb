class Translation < ActiveRecord::Base
  attr_accessible :line_id, :text, :user_id
end
