class ModifyWordModel < ActiveRecord::Migration
  def change
    remove_column :words, :quiz_id
    add_column :words, :video_id, :integer  
    add_column :words, :user_id, :integer
  end
end