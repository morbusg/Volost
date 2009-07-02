# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 12) do

  create_table "avatars", :force => true do |t|
    t.integer "parent_id"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.integer "db_file_id"
    t.string  "comment"
    t.string  "content_type"
    t.string  "filename"
    t.string  "type"
    t.string  "thumbnail"
    t.integer "user_id"
  end

  add_index "avatars", ["user_id"], :name => "index_avatars_on_user_id"

  create_table "categories", :force => true do |t|
    t.string  "title"
    t.boolean "public"
    t.integer "position"
  end

  create_table "choices", :force => true do |t|
    t.integer "topic_id"
    t.string  "description"
    t.integer "votes_count", :default => 0
  end

  create_table "communes", :force => true do |t|
    t.integer  "category_id"
    t.integer  "position"
    t.integer  "topics_count", :default => 0
    t.string   "title"
    t.string   "description"
    t.integer  "latest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data"
  end

  create_table "groups", :force => true do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.integer "commune_id"
    t.string  "title"
  end

  add_index "groups", ["user_id", "category_id", "commune_id"], :name => "index_groups_on_user_id_and_category_id_and_commune_id"

  create_table "messages", :force => true do |t|
    t.integer  "commune_id"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "receiver_id"
    t.string   "title"
    t.string   "type"
    t.string   "author"
    t.boolean  "sticky",         :default => false
    t.boolean  "locked",         :default => false
    t.integer  "replies_count",  :default => 0
    t.integer  "pictures_count", :default => 0
    t.integer  "choices_count",  :default => 0
    t.integer  "latest_id"
    t.text     "body"
    t.text     "body_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["topic_id", "commune_id", "user_id", "type"], :name => "index_messages_on_topic_id_and_commune_id_and_user_id_and_type"

  create_table "pictures", :force => true do |t|
    t.integer "parent_id"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.integer "db_file_id"
    t.string  "comment"
    t.string  "content_type"
    t.string  "filename"
    t.string  "type"
    t.string  "thumbnail"
    t.integer "user_id"
    t.integer "message_id"
  end

  create_table "searches", :force => true do |t|
    t.string   "body"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.boolean  "active",                          :default => false
    t.boolean  "admin",                           :default => false
    t.boolean  "bot",                             :default => false
    t.boolean  "moderator",                       :default => false
    t.date     "birthday"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.integer  "login_count",                     :default => 0
    t.integer  "failed_login_count",              :default => 0
    t.integer  "messages_count",                  :default => 0
    t.integer  "pictures_count",                  :default => 0
    t.integer  "received_private_messages_count", :default => 0
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "designation",                     :default => "Jäsen"
    t.string   "location"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "time_zone"
    t.text     "signature"
    t.text     "signature_html"
    t.text     "ips"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", :force => true do |t|
    t.integer "user_id"
    t.integer "choice_id"
  end

end
