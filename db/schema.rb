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

ActiveRecord::Schema.define(:version => 20130820185302) do

  create_table "event_categories", :force => true do |t|
    t.integer  "event_selector_id"
    t.string   "category"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "event_categories", ["event_selector_id"], :name => "index_event_categories_on_event_selector_id"

  create_table "event_selectors", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "times_accessed"
  end

  create_table "events", :force => true do |t|
    t.string   "source_name"
    t.string   "source_id"
    t.datetime "appointed_start"
    t.datetime "appointed_stop"
    t.integer  "typical_visit_duration"
    t.string   "venue_id"
    t.string   "venue_name"
    t.string   "venue_address"
    t.string   "venue_postal_code"
    t.string   "venue_geolocation"
    t.string   "taxonomy"
    t.string   "more_info_url"
    t.integer  "interest_level"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "title"
    t.string   "more_info_url2"
    t.string   "venue_city_state"
  end

  create_table "itinerary_events", :force => true do |t|
    t.integer  "event_selector_id"
    t.integer  "interest_level"
    t.integer  "event_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "itinerary_events", ["event_id"], :name => "index_itinerary_events_on_event_id"
  add_index "itinerary_events", ["event_selector_id"], :name => "index_itinerary_events_on_event_selector_id"

  create_table "xref_categories", :force => true do |t|
    t.string   "category"
    t.integer  "event_id"
    t.datetime "event_start"
    t.datetime "event_end"
    t.integer  "typical_visit_duration"
    t.string   "geo_coordinates"
    t.string   "zipcode"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "event_info_source"
  end

  add_index "xref_categories", ["category", "zipcode"], :name => "index_xref_categories_on_category_and_zipcode"
  add_index "xref_categories", ["category"], :name => "index_xref_categories_on_category"
  add_index "xref_categories", ["event_id"], :name => "index_xref_categories_on_event_id"

end
