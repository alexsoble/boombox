class CreatePlaycounts < ActiveRecord::Migration
  def change
    create_table :playcounts do |t|
      t.integer :video_id
      t.integer :user_id
      t.integer :play_count

      t.timestamps
    end
  end
end
