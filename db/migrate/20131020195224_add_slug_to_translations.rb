class AddSlugToTranslations < ActiveRecord::Migration
  def change
    add_column :translations, :slug, :string
    add_index :translations, :slug
  end
end
