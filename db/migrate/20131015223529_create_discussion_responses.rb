class CreateDiscussionResponses < ActiveRecord::Migration
  def change
    create_table :discussion_responses do |t|
      t.integer :discussion_question_id
      t.string :response_text
      t.integer :user_id

      t.timestamps
    end
  end
end
