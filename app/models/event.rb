class Event < ActiveRecord::Base
  self.inheritance_column = :source_name
  attr_accessible :Venue_address, :appointed_start, :appointed_stop, :interest_level, :more_info_url,
  	:source_id, :source_name, :taxonomy, :typical_visit_duration, :venue_geolocation, :venue_id, 
  	:venue_name, :venue_postal_code
	def self.update_all_events(event_count_limit = nil)
		SeatGeekEvent.load_events(event_count_limit)
	end
end

class SeatGeekEvent < Event
	def self.load_events(event_count_limit = nil)
		require 'net/http'
		http2 = Net::HTTP.start('api.seatgeek.com')
		response = http2.get("/2/events?venue.city=New+York&venue.state=NY&datetime_local.lte=#{(DateTime.now+3).to_s[0,10]}&page=1&per_page=15")
		response = http2.get("/2/events?venue.city=New+York&venue.state=NY&datetime_local.lte=#{(DateTime.now+3).to_s[0,10]}&page=1&per_page=15") unless response.code == "200"
		if response.code == "200" 
			meta = JSON.load(response.body)["meta"]
			seatgeek_events = JSON.load(response.body)["events"]
		else
			puts "SeatGeek http response.code = #{response.code}"
		end
		http2.finish
		
		return nil if meta.blank?
		event_count = 0
		SeatGeekEvent.transaction do
		self.delete_all

		taxonomies = {}
		acceptable_date_range =  DateTime.now.beginning_of_day..(DateTime.now + 2.days).end_of_day

		seatgeek_events.each do |seatgeek_event|
			next if (seatgeek_event["date_tbd"] == true) or (seatgeek_event["time_tbd"] == true)
			puts "#{seatgeek_event["datetime_local"]} #{seatgeek_event["datetime_local"].class} | #{acceptable_date_range.cover?(seatgeek_event["datetime_local"])}"
			next unless acceptable_date_range.cover?DateTime.parse(seatgeek_event["datetime_local"])
			event = self.new
    		event.title = seatgeek_event["title"]
    		event.source_id = seatgeek_event["id"]
        	event.appointed_start = seatgeek_event["datetime_local"]
    		event.appointed_stop
    		event.typical_visit_duration
    		event.venue_id = seatgeek_event['venue']["id"] 
    		event.venue_name = seatgeek_event['venue']["name"]
    		event.venue_address = seatgeek_event['venue']["address"]
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
    		event.save
    		if event_count_limit
    			event_count += 1
    			break if event_count >= event_count_limit
    		end
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
	NycParkEvent.transaction do
	xml_doc.get_elements('/rss/channel/item').each do |item| 
		event = NycParkEvent.new			
		event[:taxonomy] = item.get_text("event:categories")
		event[:title] = item.get_text("title")
		event[:source_id] = item.get_text("guid")
		event[:more_info_url] = item.get_text("link")
		event[:appointed_start] =  
			DateTime.new(item.get_text("event:startdate").to_s[0,4].to_i,
				item.get_text("event:startdate").to_s[6,2].to_i,
				item.get_text("event:startdate").to_s[8,2].to_i,
				item.get_text("event:starttime").to_s[11,2].to_i,
				item.get_text("event:starttime").to_s[14,2].to_i, 0
			)
		event[:appointed_stop] =  
			DateTime.new(item.get_text("event:enddate").to_s[0,4].to_i,
				item.get_text("event:enddate").to_s[6,2].to_i,
				item.get_text("event:enddate").to_s[8,2].to_i,
				item.get_text("event:endtime").to_s[11,2].to_i,
				item.get_text("event:endtime").to_s[14,2].to_i
			)
		event[:venue_name] = item.get_text("event:parknames")
		event[:venue_address] = item.get_text("event:location")
		event[:venue_geolocation] = item.get_text("event:coordinates")

		if event[:appointed_stop].present? && event[:appointed_start].present?
			event[:typical_visit_duration] = 
				event[:appointed_stop] - event[:appointed_start]
		end
		event[:interest_level] = 0
		event.save
		if event_count_limit
			event_count += 1
			break if event_count >= event_count_limit
		end
	end
	end
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