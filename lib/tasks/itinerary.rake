namespace :events do
	task :listc => :environment do
	  categories = Hash.new(0)
	  NycParkEvent.all.each do |nyc_event|
	    nyc_event.categories.strip.split('|').each do |category|
	    	categories[category.strip] += 1
	    end 
	  end
	  puts "categories count = #{categories.count}"
	  categories.each  {|key,value| puts "#{key} : #{value}" }
	end
	
	task :xref => :environment do
		XrefCategory.delete_all
		NycParkEvent.find_each do |nyc_event|
			XrefCategory.transaction do
				nyc_event.categories.strip.split('|').each do |category|	
					xref_category = XrefCategory.new			
					xref_category[:category] = category.strip

					nyc_event.attributes.each do |key, value|
						case key.to_sym
						when :id
							xref_category[:event_id] = value
						when :starttime
						when :startdate
							xref_category[:event_start] =  
								DateTime.new(nyc_event[:startdate].to_s[0,4].to_i,
									nyc_event[:startdate].to_s[6,2].to_i,
									nyc_event[:startdate].to_s[8,2].to_i,
									nyc_event[:starttime].to_s[11,2].to_i,
									nyc_event[:starttime].to_s[14,2].to_i, 0
								)
						when :endtime
						when :enddate
							xref_category[:event_end] =  
								DateTime.new(nyc_event[:enddate].to_s[0,4].to_i,
									nyc_event[:enddate].to_s[6,2].to_i,
									nyc_event[:enddate].to_s[8,2].to_i,
									nyc_event[:endtime].to_s[11,2].to_i,
									nyc_event[:endtime].to_s[14,2].to_i
								)
						when :coordinates
							xref_category[:geo_coordinates] = value
						# else ## For testing purposes only
						#	puts "#{key.inspect}(#{key.class}):#{value} "  ## For testing purposes only
						end

						if xref_category[:event_end].present? && xref_category[:event_start].present?
							xref_category[:typical_visit_duration] = 
								xref_category[:event_end] - xref_category[:event_start]
						end
						xref_category.save
					end
				end
				# break ## For testing purposes only
			end
		end
		puts "XrefCategory.count = #{XrefCategory.count}"
	end

	task :seatgeek1 => :environment do
		require 'net/http'
		http1 = Net::HTTP.start('api.seatgeek.com')
		# read all taxonomies into array of id+name+count
		response = http1.get("/2/taxonomies")
		response = http1.get("/2/taxonomies") unless response.code == "200"
		if response.code == "200" 
			taxonomys = JSON.load(response.body)["taxonomys"]
		end
		http1.finish

		taxonomies_index = {}
		taxonomys.each do |tax1|
			taxonomies_index[tax1["id"]] = {
				category:tax1["name"], 
				ancestor_id:tax1["parent_id"]}
		end

		taxonomies = {}
		taxonomys.each do |tax2|
			taxonomies[tax2["name"]] = {
				categories:[tax2["name"]], 
				event_count:0}
			ancestor_id = tax2["parent_id"] if tax2["parent_id"].present?
			while ancestor_id.present?
				taxonomies[tax2["name"]][:categories].insert(0,taxonomies_index[ancestor_id][:category])
				ancestor_id = taxonomies_index[ancestor_id][:ancestor_id]
			end
		end

		taxonomies.sort_by{|k,v| k}.each {|key,value| puts "#{key}: #{value.inspect}"}
		# read recent events for NYC and increment taxonomy count for each name.
		# read all taxonomies into array of id+name+count
		http1 = Net::HTTP.start('api.seatgeek.com')
		response = http1.get("/2/events?venue.city=New+York&venue.state=NY&datetime_local.lte=#{(DateTime.now+1).to_s[0,10]}&page=1")
		response = http1.get("/2/events?venue.city=New+York&venue.state=NY&datetime_local.lte=#{(DateTime.now+1).to_s[0,10]}&page=1") unless response.code == "200"
		if response.code == "200" 
			meta = JSON.load(response.body)["meta"]
			events = JSON.load(response.body)["events"]
		end
		http1.finish
		puts "meta #{meta.count}"
		puts "events #{events.count}"

	end


	task :seatgeek2 => :environment do
		require 'net/http'
		http2 = Net::HTTP.start('api.seatgeek.com')
		# read all taxonomies into array of id+name+count
		response = http2.get("/2/taxonomies")
		response = http2.get("/2/taxonomies") unless response.code == "200"
		if response.code == "200" 
			taxonomys = JSON.load(response.body)["taxonomys"]
		end
		http2.finish

		taxonomies_index = {}
		taxonomys.each do |tax1|
			taxonomies_index[tax1["id"]] = {
				category:tax1["name"], 
				ancestor_id:tax1["parent_id"]}
		end

		taxonomies = {}
		taxonomys.each do |tax2|
			taxonomies[tax2["name"]] = {
				categories:[tax2["name"]], 
				event_count:0}
			ancestor_id = tax2["parent_id"] if tax2["parent_id"].present?
			while ancestor_id.present?
				taxonomies[tax2["name"]][:categories].insert(0,taxonomies_index[ancestor_id][:category])
				ancestor_id = taxonomies_index[ancestor_id][:ancestor_id]
			end
		end

		# taxonomies.sort_by{|k,v| k}.each {|key,value| puts "#{key}: #{value.inspect}"}
		
		# read recent events for NYC and increment taxonomy count for each name.
		# read all taxonomies into array of id+name+count
		http2 = Net::HTTP.start('api.seatgeek.com')
		response = http2.get("/2/events?venue.city=New+York&venue.state=NY&datetime_local.lte=#{(DateTime.now+1).to_s[0,10]}&page=1&per_page=110")
		response = http2.get("/2/events?venue.city=New+York&venue.state=NY&datetime_local.lte=#{(DateTime.now+1).to_s[0,10]}&page=1&per_page=110") unless response.code == "200"
		if response.code == "200" 
			meta = JSON.load(response.body)["meta"]
			events = JSON.load(response.body)["events"]
		end
		http2.finish
		puts "meta #{meta.count}"
		puts "events #{events.count}"
		events.each do |event|
			event["taxonomies"].each do |taxonomy|
				# puts "#{taxonomy['name']}  : #{taxonomies[taxonomy['name']]}"
				taxonomies[taxonomy['name']][:event_count] += 1
			end
		end
		puts meta.inspect
		taxonomies.sort_by{|k,v| k}.each {|key,value| puts "#{key}: #{value.inspect}"}
	end

end


