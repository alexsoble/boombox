class AddIndexToVideoSlugs < ActiveRecord::Migration
  def change
    add_index :videos, :slug
  end
end
