class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :user_id
      t.string :question_text

      t.timestamps
    end
  end
end
