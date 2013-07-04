class DropNycParkEventTable < ActiveRecord::Migration
  def up
  	drop_table "nyc_park_events"
  end

  def down
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
end
