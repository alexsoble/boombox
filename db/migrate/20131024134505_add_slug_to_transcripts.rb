class AddSlugToTranscripts < ActiveRecord::Migration
  def change
    add_column :transcripts, :slug, :string
    add_index :transcripts, :slug
  end
end
