class CreateDiscussionQuestions < ActiveRecord::Migration
  def change
    create_table :discussion_questions do |t|
      t.integer :video_id
      t.integer :user_id
      t.string :question_text

      t.timestamps
    end
  end
end
