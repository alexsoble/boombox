class CreateFillExercises < ActiveRecord::Migration
  def change
    create_table :fill_exercises do |t|
      t.integer :user_id
      t.integer :transcript_id
      t.integer :video_id

      t.timestamps
    end
  end
end
