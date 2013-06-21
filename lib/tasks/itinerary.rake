namespace :events do
	task :listc => :environment do
	  categories = Hash.new(0)
	  NycParkEvent.all.each do |nyc_event|
	    nyc_event.categories.strip.split('|').each do |category|
	    	categories[category.strip] += 1
	    end 
	  end
	  puts "categories count = #{categories.count}"
	  puts categories.inspect
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
end

