class AddTimeToWord < ActiveRecord::Migration
  def change
    add_column :words, :time, :integer
  end
end