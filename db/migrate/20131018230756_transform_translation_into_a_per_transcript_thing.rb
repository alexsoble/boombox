class TransformTranslationIntoAPerTranscriptThing < ActiveRecord::Migration
  def change
    remove_column :translations, :line_id
    remove_column :translations, :text
    add_column :translations, :transcript_id, :integer
  end
end
