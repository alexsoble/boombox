class AddColumnsToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :lang2, :string
    add_column :requests, :video_id, :integer
    add_column :requests, :user_id, :integer
  end
end