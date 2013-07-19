class Clip < ActiveRecord::Base
  attr_accessible :duration, :interpretation_id, :start
  belongs_to :interpretation

end
