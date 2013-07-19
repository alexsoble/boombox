class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.integer :start
      t.integer :duration
      t.integer :interpretation_id

      t.timestamps
    end
  end
end
