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

ActiveRecord::Schema.define(:version => 20120507164646) do

  create_table "addresses", :force => true do |t|
    t.string   "address_1"
    t.string   "address_2"
    t.string   "address_3"
    t.string   "city"
    t.string   "district"
    t.string   "state"
    t.string   "pincode"
    t.string   "landmark"
    t.string   "phone"
    t.string   "mobile"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "admission_details", :force => true do |t|
    t.string   "admit_number"
    t.date     "admit_date"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "batches", :force => true do |t|
    t.integer  "institute_id"
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "courses", :force => true do |t|
    t.integer  "institute_id"
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "exam_results", :force => true do |t|
    t.integer  "exam_id"
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "section_id"
    t.integer  "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "exams", :force => true do |t|
    t.string   "name"
    t.date     "start"
    t.date     "end"
    t.integer  "examable_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "examable_type"
  end

  create_table "fee_collection_events", :force => true do |t|
    t.integer  "institute_id"
    t.string   "name"
    t.date     "due_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "fee_collections", :force => true do |t|
    t.integer  "user_id"
    t.integer  "fee_collection_event_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "institute_sessions", :force => true do |t|
    t.integer  "institute_id"
    t.date     "start"
    t.date     "end"
    t.boolean  "current"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "institutes", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "parent_details", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "section_attendances", :force => true do |t|
    t.integer  "section_id"
    t.integer  "institute_session_id"
    t.integer  "user_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.date     "date"
  end

  create_table "sections", :force => true do |t|
    t.integer  "batch_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_details", :force => true do |t|
    t.string   "gender"
    t.string   "blood_group"
    t.string   "birth_place"
    t.string   "nationality"
    t.string   "mother_tongue"
    t.string   "category"
    t.string   "religion"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "user_type"
    t.string   "username"
    t.string   "pass_hash"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "institute_id"
    t.string   "one_time_login"
    t.string   "type"
    t.integer  "section_id"
    t.date     "dob"
  end

end