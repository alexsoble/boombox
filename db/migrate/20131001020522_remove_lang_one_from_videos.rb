class RemoveLangOneFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :lang1
  end
end
