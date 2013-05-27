class AddLangToVideoTakeOneFromInterpretation < ActiveRecord::Migration
  def change
    remove_column :interpretations, :lang1
    add_column :videos, :lang1, :string
  end
end
