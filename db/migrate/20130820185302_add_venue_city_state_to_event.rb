class AddVenueCityStateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :venue_city_state, :string
  end
end
