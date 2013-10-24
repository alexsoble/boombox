class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :note_text
      t.integer :user_id
      t.integer :video_id
      t.integer :interpretation_id

      t.timestamps
    end
  end
end
