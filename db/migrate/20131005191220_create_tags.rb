class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :user_id
      t.integer :video_id
      t.boolean :type_lang
      t.boolean :type_difficulty
      t.boolean :type_artist
      t.boolean :type_style

      t.timestamps
    end
  end
end
