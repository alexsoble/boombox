class AddDurationToLines < ActiveRecord::Migration
  def change
    add_column :lines, :duration, :integer, :default => 4
  end
end
