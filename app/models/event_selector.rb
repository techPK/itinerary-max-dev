class EventSelector < ActiveRecord::Base
  attr_accessible :times_accessed
  has_many :itinerary_events, dependent: :destroy
  has_many :events, through: :itinerary_events
  has_many :event_categories, dependent: :destroy
end
