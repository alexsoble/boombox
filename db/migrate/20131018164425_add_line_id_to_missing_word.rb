class AddLineIdToMissingWord < ActiveRecord::Migration
  def change
    add_column :missing_words, :line_id, :integer
  end
end
