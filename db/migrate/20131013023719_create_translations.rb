class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.integer :line_id
      t.integer :user_id
      t.string :text

      t.timestamps
    end
  end
end
