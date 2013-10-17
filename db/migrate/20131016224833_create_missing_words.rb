class CreateMissingWords < ActiveRecord::Migration
  def change
    create_table :missing_words do |t|
      t.integer :fill_exercise_id
      t.string :word_text

      t.timestamps
    end
  end
end
