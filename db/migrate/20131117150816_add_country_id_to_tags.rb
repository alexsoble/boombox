class AddCountryIdToTags < ActiveRecord::Migration
  def change
    add_column :tags, :country_id, :integer
  end
end
