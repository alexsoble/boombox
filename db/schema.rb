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

ActiveRecord::Schema.define(:version => 20130822145834) do

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

  create_table "interpretations", :force => true do |t|
    t.string   "lang2"
    t.integer  "video_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "user_id"
    t.boolean  "published",  :default => false
    t.string   "difficulty"
    t.text     "note"
  end

  create_table "lines", :force => true do |t|
    t.string   "lang1"
    t.string   "lang2"
    t.integer  "time"
    t.integer  "upvotes"
    t.integer  "downvotes"
    t.integer  "interpretation_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "duration",          :default => 4
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
  end

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "lang1"
    t.string   "youtube_id"
  end

  create_table "votes", :force => true do |t|
    t.integer  "direction"
    t.integer  "interpretation_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "words", :force => true do |t|
    t.integer  "quiz_id"
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
