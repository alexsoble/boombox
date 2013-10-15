class Translation < ActiveRecord::Base
  attr_accessible :line_id, :text, :user_id, :language_id
end
