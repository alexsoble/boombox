class CreateTagVotes < ActiveRecord::Migration
  def change
    create_table :tag_votes do |t|
      t.integer :tag_id
      t.integer :user_id
      t.integer :value

      t.timestamps
    end
  end
end
