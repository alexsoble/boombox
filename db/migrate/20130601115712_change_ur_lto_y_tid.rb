class ChangeUrLtoYTid < ActiveRecord::Migration
  def change
    add_column :videos, :youtube_id, :string
    remove_column :videos, :url
  end
end
