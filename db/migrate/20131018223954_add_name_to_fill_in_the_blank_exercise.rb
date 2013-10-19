class AddNameToFillInTheBlankExercise < ActiveRecord::Migration
  def change
    add_column :fill_exercises, :name, :string
  end
end
