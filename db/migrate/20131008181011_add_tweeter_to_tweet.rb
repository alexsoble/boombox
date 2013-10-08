class AddTweeterToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :tweeter, :string
  end
end
