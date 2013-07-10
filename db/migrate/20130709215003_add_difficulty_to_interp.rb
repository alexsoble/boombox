class AddDifficultyToInterp < ActiveRecord::Migration
   def change
    add_column :interpretations, :difficulty, :string
  end
end