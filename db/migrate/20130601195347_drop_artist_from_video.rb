class DropArtistFromVideo < ActiveRecord::Migration
  def change
    remove_column :videos, :artist
  end
end