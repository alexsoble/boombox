class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.integer :quiz_id
      t.string :text

      t.timestamps
    end
  end
end
