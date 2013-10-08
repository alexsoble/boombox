class DefinitionVote < ActiveRecord::Base
  attr_accessible :definition_id, :user_id, :value

  belongs_to :definition
  belongs_to :user
end
