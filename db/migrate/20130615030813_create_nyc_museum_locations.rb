class CreateNycMuseumLocations < ActiveRecord::Migration
  def change
    create_table :nyc_museum_locations do |t|
      t.string :part_1
      t.string :name
      t.string :phone
      t.string :url
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zip
      t.string :coordinates

      t.timestamps
    end
  end
end
