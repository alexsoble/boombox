class CorrectDefinitionIdSpelling < ActiveRecord::Migration
  def change
    remove_column :definition_votes, :definiiton_id
    add_column :definition_votes, :definition_id, :integer
  end
end
