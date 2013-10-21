class AddSlugToFillExercise < ActiveRecord::Migration
  def change
    add_column :fill_exercises, :slug, :string
  end
end
