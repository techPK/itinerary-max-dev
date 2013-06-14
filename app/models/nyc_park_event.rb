class NycParkEvent < ActiveRecord::Base
  attr_accessible :description, :guid, :link, :published_at, :title
  attr_accessible :parkids, :parknames, :startdate, :enddate, :starttime, :image
  attr_accessible :endtime, :contact_phone, :location, :categories, :coordinates, :pubDate

  def self.update_from_feed(feed_url = 'http://www.nycgovparks.org/xml/events_300_rss.xml')
	require 'open-uri'
    
    xml_doc = REXML::Document.new open(feed_url)
    NycParkEvent.delete_all
	xml_doc.get_elements('/rss/channel/item').each do |item|  
		park_event = {}
		item.each_element_with_text do |element|
			park_event[element.name.to_sym] = element.text
		end
		# ele.each_element_with_text {|e| puts "#{e.name} => #{e.text}"}
		unless park_event.empty?
			NycParkEvent.create!(park_event)
		end
    end
  end
end