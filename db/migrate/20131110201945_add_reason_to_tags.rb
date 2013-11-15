class AddReasonToTags < ActiveRecord::Migration
  def change
    add_column :tags, :reason, :string
  end
end
