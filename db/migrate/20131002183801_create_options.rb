class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.integer :challenge_id
      t.string :answer_text

      t.timestamps
    end
  end
end
