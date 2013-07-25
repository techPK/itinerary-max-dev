class CreateItineraryEvents < ActiveRecord::Migration
  def change
    create_table :itinerary_events do |t|
      t.belongs_to :event_selector
      t.integer :interest_level
      t.belongs_to :event

      t.timestamps
    end
    add_index :itinerary_events, :event_selector_id
    add_index :itinerary_events, :event_id
  end
end
