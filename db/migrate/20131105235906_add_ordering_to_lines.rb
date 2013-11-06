class AddOrderingToLines < ActiveRecord::Migration
  def change
    add_column :lines, :ordering, :integer
  end
end
