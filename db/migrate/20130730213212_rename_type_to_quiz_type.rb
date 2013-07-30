class RenameTypeToQuizType < ActiveRecord::Migration
  def change
    remove_column :quizzes, :type
    add_column :quizzes, :quiz_type, :string
  end
end
