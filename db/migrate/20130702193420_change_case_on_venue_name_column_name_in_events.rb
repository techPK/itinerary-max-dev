class ChangeCaseOnVenueNameColumnNameInEvents < ActiveRecord::Migration
  def up
  	rename_column :events, :Venue_address, :venue_address
  end

  def down
  	rename_column :events, :venue_address, :Venue_address
  end
end
