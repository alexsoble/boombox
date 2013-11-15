class ReconfigureTags < ActiveRecord::Migration
  def change
    remove_column :tags, :name
    remove_column :tags, :type_lang
    remove_column :tags, :type_difficulty
    remove_column :tags, :type_artist
    remove_column :tags, :type_style
    add_column :tags, :language_id, :integer
    add_column :tags, :difficulty_id, :integer
  end
end
