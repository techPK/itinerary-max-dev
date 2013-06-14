class AddMoreFieldsToNycParkEvent < ActiveRecord::Migration
  def change
    add_column :nyc_park_events, :parkids, :string
    add_column :nyc_park_events, :parknames, :string
    add_column :nyc_park_events, :startdate, :date
    add_column :nyc_park_events, :enddate, :date
    add_column :nyc_park_events, :starttime, :time
    add_column :nyc_park_events, :endtime, :time
    add_column :nyc_park_events, :contact_phone, :string
    add_column :nyc_park_events, :location, :string
    add_column :nyc_park_events, :categories, :string
    add_column :nyc_park_events, :coordinates, :string
    add_column :nyc_park_events, :image, :string
    add_column :nyc_park_events, :pubDate, :datetime
  end
end
