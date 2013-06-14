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

ActiveRecord::Schema.define(:version => 20130614154008) do

  create_table "nyc_museums", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "address"
    t.string   "closing"
    t.string   "rates"
    t.string   "specials"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "nyc_park_events", :force => true do |t|
    t.string   "title"
    t.string   "guid"
    t.string   "link"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "parkids"
    t.string   "parknames"
    t.date     "startdate"
    t.date     "enddate"
    t.time     "starttime"
    t.time     "endtime"
    t.string   "contact_phone"
    t.string   "location"
    t.string   "categories"
    t.string   "coordinates"
    t.string   "image"
    t.datetime "pubDate"
  end

end
