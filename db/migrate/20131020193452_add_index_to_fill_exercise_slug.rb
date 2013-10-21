class AddIndexToFillExerciseSlug < ActiveRecord::Migration
  def change
    add_index :fill_exercises, :slug
  end
end
