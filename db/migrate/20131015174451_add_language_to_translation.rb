class AddLanguageToTranslation < ActiveRecord::Migration
  def change
    add_column :translations, :language_id, :integer
  end
end