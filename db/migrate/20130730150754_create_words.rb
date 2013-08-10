class CreateWords < ActiveRecord::Migration
  def change
    drop_table :words
    create_table :words do |t|
      t.integer :quiz_id
      t.string :text

      t.timestamps
    end
  end
end
