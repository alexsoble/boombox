class Remove < ActiveRecord::Migration
  def change
    remove_column :lines, :upvotes
    remove_column :lines, :downvotes
  end
end
