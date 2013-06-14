class RemovePublishedAtFromNycParkEvent < ActiveRecord::Migration
  def up
  	remove_column :nyc_park_events,  :published_at
  end

  def down
  	add_column :nyc_park_events,  :published_at, :datetime
  end
end
