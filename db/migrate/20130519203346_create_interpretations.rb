class CreateInterpretations < ActiveRecord::Migration
  def change
    create_table :interpretations do |t|
      t.string :lang1
      t.string :lang2
      t.integer :video_id

      t.timestamps
    end
  end
end
