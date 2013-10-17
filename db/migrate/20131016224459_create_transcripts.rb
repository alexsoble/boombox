class CreateTranscripts < ActiveRecord::Migration
  def change
    create_table :transcripts do |t|
      t.integer :user_id
      t.integer :video_id
      t.integer :interpretation_id

      t.timestamps
    end
  end
end
