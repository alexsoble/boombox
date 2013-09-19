class CreateVocabwords < ActiveRecord::Migration
  def change
    create_table :vocabwords do |t|
      t.integer :interpretation_id
      t.integer :user_id
      t.string :word_text
      t.string :definition

      t.timestamps
    end
  end
end
