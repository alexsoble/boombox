class AddUserIdAndExerciseIDtoCompletedExercise < ActiveRecord::Migration
  def change
    add_column :completed_exercises, :user_id, :integer
    add_column :completed_exercises, :fill_exercise_id, :integer
  end
end
