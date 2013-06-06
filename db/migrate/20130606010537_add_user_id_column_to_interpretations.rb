class AddUserIdColumnToInterpretations < ActiveRecord::Migration
  def change
    add_column :interpretations, :user_id, :integer
  end
end
