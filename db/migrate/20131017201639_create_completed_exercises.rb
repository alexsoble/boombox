class CreateCompletedExercises < ActiveRecord::Migration
  def change
    create_table :completed_exercises do |t|

      t.timestamps
    end
  end
end
