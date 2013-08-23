class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.integer :interpretation_id
      t.integer :user_id
      t.string :word_text

      t.timestamps
    end
  end
end
