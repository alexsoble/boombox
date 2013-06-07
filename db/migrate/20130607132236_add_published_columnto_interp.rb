class AddPublishedColumntoInterp < ActiveRecord::Migration
  def change
    add_column :interpretations, :published, :boolean, :default => false
  end
end
