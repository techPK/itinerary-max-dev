class EventSelector < ActiveRecord::Base
  attr_accessible :times_accessed
  has_many :event_categories, dependent: :destroy
end
