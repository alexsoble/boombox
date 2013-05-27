class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :lang1
      t.string :lang2
      t.integer :time
      t.integer :upvotes
      t.integer :downvotes
      t.integer :interpretation_id

      t.timestamps
    end
  end
end
