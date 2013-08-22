class AddNoteToInterpretation < ActiveRecord::Migration
  def change
    add_column :interpretations, :note, :text
  end
end