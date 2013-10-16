class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :user_id
      t.integer :language_id
      t.boolean :teach
      t.string :level

      t.timestamps
    end
  end
end
