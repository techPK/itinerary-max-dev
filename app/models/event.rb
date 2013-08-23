class Event < ActiveRecord::Base
	has_many :itinerary_events, dependent: :destroy
	has_many :event_selectors , through: :itinerary_events, dependent: :destroy
	self.inheritance_column = :source_name
	attr_accessible :Venue_address, :appointed_start, :appointed_stop, :interest_level, :more_info_url,
		:source_id, :source_name, :taxonomy, :typical_visit_duration, :venue_geolocation, :venue_id, 
		:venue_name, :venue_postal_code, :venue_city_state

		scope :manhattan, where("venue_postal_code LIKE '100%' \
			OR venue_postal_code LIKE '101%' \
			OR venue_postal_code LIKE '102%' ") # 102 101 
		scope :bronx, where("venue_postal_code LIKE '104%' ") 
		scope :brooklyn, where("venue_postal_code LIKE '112%' ") 
		scope :queens, where("venue_postal_code LIKE '111%' \
			OR venue_postal_code LIKE '113%' 
			OR venue_postal_code LIKE '114%' 
			OR venue_postal_code LIKE '116%' ") # 114 111 116  
		scope :staten_island, where("venue_postal_code LIKE '103%' ") 

		scope :today, lambda {where("date(appointed_start) = ?", (DateTime.now + 0).to_date)} 
		scope :tomorrow, lambda {where("date(appointed_start) = ?", (DateTime.now + 1).to_date)} 
		scope :beyond_tomorrow, lambda {where("date(appointed_start) = ?", (DateTime.now + 2).to_date)} 

		scope :early_morning, where("time(appointed_start) between time(?) and time(?)",  '4:00' ,'7:59') 
		scope :morning, where("time(appointed_start) between time(?) and time(?)",  '8:00' ,'11:59')
		scope :afternoon, where("time(appointed_start) between time(?) and time(?)",  '12:00' ,'15:59')
		scope :evening, where("time(appointed_start) between time(?) and time(?)",  '16:00' ,'19:59')
		scope :night, where("time(appointed_start) between time(?) and time(?)",  '20:00' ,'23:59')
		scope :late_night, where("time(appointed_start) between time(?) and time(?)",  '00:00' ,'3:59')

	def self.update_all_events(event_count_limit = nil)
		SeatGeekEvent.load_events(event_count_limit)
	end

	def self.zip_area_name(zipcode)
	  return nil unless (zipcode.class == String) 
	  return nil unless (zipcode =~ /^\d{5}$/)
	  case zipcode[0,3]
	    when '100', '101', '102'
	      :manhattan
	    when '104'
	      :bronx
	    when '112'
	      :brooklyn
	    when '111', '113', '114','116'
	      :queens
	    when '103'
	      :staten_island
	    else
	      nil
	  end
	end
end

class SeatGeekEvent < Event
	def self.load_events(event_count_limit = nil)
		require 'net/http'
		http2 = Net::HTTP.start('api.seatgeek.com')
		event_count = 0
		page_number = 0
		begin
			page_number += 1
			response = http2.get("/2/events?aid=10548&venue.state=NY&datetime_local.lte=#{(DateTime.now+3.days).to_s[0,10]}&page=#{page_number}&per_page=200")
			response = http2.get("/2/events?aid=10548&venue.state=NY&datetime_local.lte=#{(DateTime.now+3.days).to_s[0,10]}&page=#{page_number}&per_page=200") unless response.code == "200"
			break if response.code != "200" 
			meta = JSON.load(response.body)["meta"]
			event_count_limit ||= meta['total'] 
			seatgeek_events = JSON.load(response.body)["events"]
			break if seatgeek_events.blank?
			event_count = get_page_events(seatgeek_events,event_count_limit,event_count)
			if event_count_limit
				break if event_count >= event_count_limit
			end
		end until(event_count >= event_count_limit) 

		http2.finish
		SeatGeekEvent.where(updated_at:(DateTime.now-3.hours)).delete_all
		event_count
	end



	def self.get_page_events(seatgeek_events,event_count_limit,event_count)	
		taxonomies = {}
		acceptable_date_range =  DateTime.now.beginning_of_day..(DateTime.now + 2.days).end_of_day

		seatgeek_events.each do |seatgeek_event|
			next unless SeatGeekEvent.zip_area_name(seatgeek_event['venue']["postal_code"])
			next if (seatgeek_event["date_tbd"] == true) or (seatgeek_event["time_tbd"] == true)
			puts "#{seatgeek_event["datetime_local"]} #{seatgeek_event["datetime_local"].class} | #{acceptable_date_range.cover?(seatgeek_event["datetime_local"])}"
			next unless acceptable_date_range.cover?DateTime.parse(seatgeek_event["datetime_local"])
			event = self.find_or_initialize_by_source_id(seatgeek_event["id"])
			event.title = seatgeek_event["title"]
			event.source_id = seatgeek_event["id"]
	    	event.appointed_start = seatgeek_event["datetime_local"]
			event.appointed_stop
			event.typical_visit_duration = 3.hours
			event.venue_id = seatgeek_event['venue']["id"] 
			event.venue_name = seatgeek_event['venue']["name"]
			event.venue_address = seatgeek_event['venue']["address"]
			event.venue_city_state = seatgeek_event['venue']["city"] + ', ' + seatgeek_event['venue']["state"]
			event.venue_postal_code =  seatgeek_event['venue']["postal_code"]
			event.venue_geolocation =  seatgeek_event['venue']["location"]
			
			event_taxonomies = []
			seatgeek_event["taxonomies"].each do |tax| 
				event_taxonomies << tax["name"]
			end
			event.taxonomy = event_taxonomies.join(' | ')

			event.more_info_url = seatgeek_event['url']
			event.more_info_url2 = seatgeek_event['performers'].first["url"]
			event.interest_level = 0
			event.save ##### 
			event_count += 1
			if event_count_limit
				return event_count if event_count >= event_count_limit
			end
		end
		event_count
	end

end

class NycParkEvent < Event
  def self.load_events(event_count_limit = nil)
	require 'open-uri'
	require 'rexml/document'
    
	feed_url = 'http://www.nycgovparks.org/xml/events_300_rss.xml'
    xml_doc = REXML::Document.new open(feed_url)
	event_count = 0
#	NycParkEvent.transaction do
	xml_doc.get_elements('/rss/channel/item').each do |item| 
		event = self.find_or_initialize_by_source_id(item.get_text("guid").value)
		event.taxonomy = item.get_text("event:categories").value
		event.title = item.get_text("title").value
		event.source_id = item.get_text("guid").value
		event.more_info_url = item.get_text("link").value
		event.appointed_start =  
			DateTime.new(item.get_text("event:startdate").value[0,4].to_i,
				item.get_text("event:startdate").value[6,2].to_i,
				item.get_text("event:startdate").value[8,2].to_i,
				item.get_text("event:starttime").value[11,2].to_i,
				item.get_text("event:starttime").value[14,2].to_i, 0
			)
		event.appointed_stop =  
			DateTime.new(item.get_text("event:enddate").value[0,4].to_i,
				item.get_text("event:enddate").value[6,2].to_i,
				item.get_text("event:enddate").value[8,2].to_i,
				item.get_text("event:endtime").value[11,2].to_i,
				item.get_text("event:endtime").value[14,2].to_i
			)
		event.venue_name = item.get_text("event:parknames").try(:value)
		event.venue_address = item.get_text("event:location").try(:value)
		event.venue_geolocation = item.get_text("event:coordinates").try(:value)

		if event[:appointed_stop].present? && event[:appointed_start].present?
			event.typical_visit_duration = 
				event[:appointed_stop] - event[:appointed_start]
		end
		event.interest_level = 0
		event.save
		if event_count_limit
			event_count += 1
			break if event_count >= event_count_limit
		end
	end
#	end
	event_count
  end
end

# class NycMuseum # < Event
#  # attr_accessible :address, :closing, :name, :phone, :rates, :specials

#   def self.update_from_feed(feed_url = 'http://nycopendata.socrata.com/api/file_data/g5iiDl27zmKcETR-hHG58WnVB4ZKgnCUMwnK_dHW2AY?filename=NYCGO_museums%2520and%2520galleries_001.xml', 
#   	main_elements='/museums/museum')

# 	require 'open-uri'
    
#     xml_doc = REXML::Document.new open(feed_url)
#     self.delete_all
# 	xml_doc.get_elements(main_elements).each do |main_element|  
# 		this_event = {}
# 		main_element.each_element_with_text do |element|
# 			this_event[element.name.to_sym] = element.cdatas.join(';')
# 		end
# 		# ele.each_element_with_text {|e| puts "#{e.name} => #{e.text}"}
# 		unless this_event.empty?
# 			self.create!(this_event)

			
# 		end
#     end
#   end

# end


# class NycMuseumLocationX # < Event
#  attr_accessible :address1, :address2, :city, :coordinates, :name, :part_1, :phone, :url, :zip
#    require 'csv'

#     csv_text = File.read('db\WIP datasets\nyc_museums_part_2a.csv')
#     csv = CSV.parse(csv_text, :headers => true)
#     csv.each {|row| NycMuseumLocation.create!(row.to_hash)}

#     csv = CSV.read('db\WIP datasets\nyc_museums_part_2a.csv',{ :headers => true, :col_sep => "\t"})
# end