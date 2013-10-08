class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :video_id
      t.integer :user_id
      t.string :twitter_id

      t.timestamps
    end
  end
end
