class CreateOptionVotes < ActiveRecord::Migration
  def change
    create_table :option_votes do |t|
      t.integer :user_id
      t.integer :option_id

      t.timestamps
    end
  end
end
