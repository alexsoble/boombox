# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131117150816) do

  create_table "challenges", :force => true do |t|
    t.integer  "user_id"
    t.string   "question_text"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "video_id"
    t.integer  "interpretation_id"
  end

  create_table "classrooms", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clips", :force => true do |t|
    t.integer  "start"
    t.integer  "duration"
    t.integer  "interpretation_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "line_id"
    t.string   "comment_text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "completed_exercises", :force => true do |t|
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.integer  "fill_exercise_id"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "definition_votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "definition_id"
  end

  create_table "definitions", :force => true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.integer  "word_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "definitions", ["slug"], :name => "index_definitions_on_slug"

  create_table "difficulties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "discussion_questions", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.string   "question_text"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "interpretation_id"
  end

  create_table "discussion_responses", :force => true do |t|
    t.integer  "discussion_question_id"
    t.string   "response_text"
    t.integer  "user_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "fill_exercises", :force => true do |t|
    t.integer  "user_id"
    t.integer  "transcript_id"
    t.integer  "video_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
    t.string   "slug"
  end

  add_index "fill_exercises", ["slug"], :name => "index_fill_exercises_on_slug"

  create_table "interests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "language_id"
    t.boolean  "teach"
    t.string   "level"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "interpretations", :force => true do |t|
    t.integer  "video_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.string   "slug"
  end

  add_index "interpretations", ["slug"], :name => "index_interpretations_on_slug"

  create_table "keywords", :force => true do |t|
    t.integer  "interpretation_id"
    t.integer  "user_id"
    t.string   "word_text"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lines", :force => true do |t|
    t.string   "lang1"
    t.string   "lang2"
    t.integer  "time"
    t.integer  "interpretation_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "duration",          :default => 4
    t.integer  "transcript_id"
    t.integer  "video_id"
    t.integer  "ordering"
  end

  create_table "links", :force => true do |t|
    t.string   "url"
    t.text     "excerpt"
    t.integer  "language_id"
    t.integer  "user_id"
    t.integer  "video_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "interpretation_id"
  end

  create_table "lyrics", :force => true do |t|
    t.integer  "interpretation_id"
    t.integer  "video_id"
    t.integer  "user_id"
    t.text     "lyrics_text"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "missing_words", :force => true do |t|
    t.integer  "fill_exercise_id"
    t.string   "word_text"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "line_id"
  end

  create_table "notes", :force => true do |t|
    t.text     "note_text"
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "interpretation_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "option_votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "option_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "options", :force => true do |t|
    t.integer  "challenge_id"
    t.string   "answer_text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "playcounts", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.integer  "play_count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quizzes", :force => true do |t|
    t.integer  "interpretation_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "name"
    t.string   "description"
    t.string   "quiz_type"
    t.integer  "user_id"
  end

  create_table "requests", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "lang2"
    t.integer  "video_id"
    t.integer  "user_id"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stars", :force => true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "interpretation_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "translation_id"
    t.integer  "transcript_id"
  end

  create_table "tag_votes", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "user_id"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "language_id"
    t.integer  "difficulty_id"
    t.string   "reason"
    t.integer  "country_id"
  end

  create_table "transcripts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "interpretation_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "slug"
  end

  add_index "transcripts", ["slug"], :name => "index_transcripts_on_slug"

  create_table "translated_lines", :force => true do |t|
    t.integer  "line_id"
    t.string   "lang2"
    t.integer  "translation_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "translations", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "language_id"
    t.integer  "transcript_id"
    t.integer  "video_id"
    t.string   "slug"
  end

  add_index "translations", ["slug"], :name => "index_translations_on_slug"

  create_table "tweets", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.string   "twitter_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "tweeter"
    t.integer  "interpretation_id"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.string   "image_url"
    t.text     "bio"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "school_id"
    t.boolean  "teacher"
    t.integer  "classroom_id"
    t.string   "slug"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          :default => 0, :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["slug"], :name => "index_users_on_slug"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "youtube_id"
    t.string   "slug"
    t.integer  "duration"
  end

  add_index "videos", ["slug"], :name => "index_videos_on_slug"

  create_table "vocabwords", :force => true do |t|
    t.integer  "interpretation_id"
    t.integer  "user_id"
    t.string   "word_text"
    t.string   "definition"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "direction"
    t.integer  "interpretation_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "words", :force => true do |t|
    t.string   "text"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "video_id"
    t.integer  "user_id"
    t.integer  "time"
    t.integer  "interpretation_id"
  end

end
