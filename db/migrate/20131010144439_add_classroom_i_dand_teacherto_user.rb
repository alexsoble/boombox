class AddClassroomIDandTeachertoUser < ActiveRecord::Migration
  def change
    add_column :users, :teacher, :boolean
    add_column :users, :classroom_id, :integer
  end
end
