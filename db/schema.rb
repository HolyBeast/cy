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

ActiveRecord::Schema.define(:version => 20130104031553) do

  create_table "heros", :force => true do |t|
    t.string   "firstname",  :limit => 12
    t.string   "lastname",   :limit => 17
    t.string   "race"
    t.string   "nation"
    t.string   "sex",        :limit => 1
    t.integer  "rank",       :limit => 2
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "heros", ["lastname", "firstname"], :name => "index_heros_on_lastname_and_firstname", :unique => true
  add_index "heros", :user_id

  create_table "users", :force => true do |t|
    t.string   "login",         :limit => 20
    t.string   "pass",          :limit => 40
    t.string   "email",         :limit => 100
    t.string   "contact_email", :limit => 100
    t.integer  "state",         :limit => 2
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
