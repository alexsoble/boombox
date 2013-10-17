class AddTranscriptIdToLine < ActiveRecord::Migration
  def change
    add_column :lines, :transcript_id, :integer
    add_column :lines, :video_id, :integer
  end
end
