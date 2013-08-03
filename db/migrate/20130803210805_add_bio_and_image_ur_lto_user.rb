class AddBioAndImageUrLtoUser < ActiveRecord::Migration
  def change
    add_column :users, :image_url, :string
    add_column :users, :bio, :text
  end
end