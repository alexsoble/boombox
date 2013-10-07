class CreateDefinitionVotes < ActiveRecord::Migration
  def change
    create_table :definition_votes do |t|
      t.integer :user_id
      t.integer :definiiton_id
      t.integer :value

      t.timestamps
    end
  end
end
