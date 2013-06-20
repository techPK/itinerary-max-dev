class NycMuseumLocation < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :coordinates, :name, :part_1, :phone, :url, :zip
end
