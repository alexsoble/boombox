class ChangePlayCountToInteger < ActiveRecord::Migration
  def change
    change_column :playcounts, :play_count, :integer
  end
end
