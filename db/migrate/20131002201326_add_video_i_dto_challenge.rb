class AddVideoIDtoChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :video_id, :integer  
  end
end
