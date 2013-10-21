class AddSlugToInterpretations < ActiveRecord::Migration
  def change
    add_column :interpretations, :slug, :string
    add_index :interpretations, :slug
  end
end
