class RemovePublishedAndLang2AndNoteAndDifficultyFromInterp < ActiveRecord::Migration
  def change
    remove_column :interpretations, :published
    remove_column :interpretations, :note
    remove_column :interpretations, :difficulty
    remove_column :interpretations, :lang2
  end
end