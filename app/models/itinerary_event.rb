class ItineraryEvent < ActiveRecord::Base
  belongs_to :event_selector
  belongs_to :event
  attr_accessible :interest_level, :event_id, :event_selector_id
end
