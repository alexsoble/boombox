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

ActiveRecord::Schema.define(:version => 20131013203812) do

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
  end

  create_table "discussion_questions", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.string   "question_text"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "interpretation_id"
  end

  create_table "interpretations", :force => true do |t|
    t.integer  "video_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

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
  end

  create_table "tag_votes", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "user_id"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "video_id"
    t.boolean  "type_lang"
    t.boolean  "type_difficulty"
    t.boolean  "type_artist"
    t.boolean  "type_style"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "translations", :force => true do |t|
    t.integer  "line_id"
    t.integer  "user_id"
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
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
  end

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "youtube_id"
  end

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
