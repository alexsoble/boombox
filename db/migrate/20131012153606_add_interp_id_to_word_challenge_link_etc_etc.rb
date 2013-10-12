class AddInterpIdToWordChallengeLinkEtcEtc < ActiveRecord::Migration
  def change
    add_column :words, :interpretation_id, :integer
    add_column :challenges, :interpretation_id, :integer
    add_column :discussion_questions, :interpretation_id, :integer
    add_column :links, :interpretation_id, :integer
    add_column :tweets, :interpretation_id, :integer
  end
end
