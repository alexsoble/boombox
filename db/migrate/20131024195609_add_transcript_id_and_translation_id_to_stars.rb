class AddTranscriptIdAndTranslationIdToStars < ActiveRecord::Migration
  def change
    add_column :stars, :translation_id, :integer
    add_column :stars, :transcript_id, :integer
  end
end
