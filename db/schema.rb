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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170806163542) do

  create_table "conversations", force: :cascade do |t|
    t.string   "title"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_trash"
    t.boolean  "recipient_trash"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "slug"
  end

  create_table "forums", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.boolean  "unread"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "parent_id"
    t.boolean  "editable",   default: true
  end

  create_table "topic_saves", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "forum_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "admin"
    t.string   "slug"
    t.string   "token"
  end

  create_table "votes", force: :cascade do |t|
    t.boolean  "vote"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
