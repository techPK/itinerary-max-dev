class DropTableNycMuseumLocation < ActiveRecord::Migration
  def up
  	drop_table "nyc_museum_locations"
  	drop_table "nyc_museums"
  end

  def down
  	create_table "nyc_museum_locations", :force => true do |t|
	    t.string   "part_1"
	    t.string   "name"
	    t.string   "phone"
	    t.string   "url"
	    t.string   "address1"
	    t.string   "address2"
	    t.string   "city"
	    t.string   "zip"
	    t.string   "coordinates"
	    t.datetime "created_at",  :null => false
	    t.datetime "updated_at",  :null => false
  	end
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
  end
end
