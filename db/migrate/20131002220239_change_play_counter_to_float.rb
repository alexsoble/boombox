class ChangePlayCounterToFloat < ActiveRecord::Migration
  def change
    change_column :playcounts, :play_count, :float
  end
end
