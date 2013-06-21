class FixGeoCoordinatesNameInXrefCategory < ActiveRecord::Migration
  def up
  	rename_column :xref_categories, :geo_location, :geo_coordinates
  end

  def down
  	rename_column :xref_categories, :geo_coordinates, :geo_location
  end
end
