class Option < ActiveRecord::Base
  attr_accessible :answer_text, :challenge_id
  belongs_to :challenge

  def votes
    return OptionVote.where(:option_id => self.id).length
  end 

end
