class AddSlugToDefinitions < ActiveRecord::Migration
  def change
    add_column :definitions, :slug, :string
    add_index :definitions, :slug
  end
end
