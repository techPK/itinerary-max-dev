class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :source_name
      t.string :source_id
      t.datetime :appointed_start
      t.datetime :appointed_stop
      t.integer :typical_visit_duration
      t.string :venue_id
      t.string :venue_name
      t.string :Venue_address
      t.string :venue_postal_code
      t.string :venue_geolocation
      t.string :taxonomy
      t.string :more_info_url
      t.integer :interest_level

      t.timestamps
    end
  end
end
