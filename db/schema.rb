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

ActiveRecord::Schema.define(:version => 20110926184510) do

  create_table "admin_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "email"
    t.string   "status",       :default => "ACTIVE"
    t.string   "session_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "letters", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.datetime "sent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "next_date"
    t.string   "status",       :default => "NEW"
    t.string   "hashed"
  end

  create_table "mappings", :force => true do |t|
    t.string   "email"
    t.string   "fake_mail"
    t.integer  "sender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.string   "lang",       :default => "ro"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "special"
  end

  create_table "recipients", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "relation"
    t.integer  "sender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "senders", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     :default => "NEW"
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "signature"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
