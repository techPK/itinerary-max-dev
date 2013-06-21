class XrefCategory < ActiveRecord::Base
  belongs_to :event
  attr_accessible :category, :event_end, :event_start, :geo_location, :typical_visit_duration, :zipcode
end
