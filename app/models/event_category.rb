class EventCategory < ActiveRecord::Base
  belongs_to :event_selector
  attr_accessible :category
end
