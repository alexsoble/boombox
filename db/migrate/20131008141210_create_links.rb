class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.text :excerpt
      t.integer :language_id
      t.integer :user_id
      t.integer :video_id

      t.timestamps
    end
  end
end
