class CreateQuizzes < ActiveRecord::Migration
  def change
    drop_table :quizzes
    create_table :quizzes do |t|
      t.integer :interpretation_id
      t.string :type

      t.timestamps
    end
  end
end
