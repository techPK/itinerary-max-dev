module EventsHelper
	def seconds_to_hours_and_minutes_time(seconds = nil)
		return nil if seconds.blank?
		minutes, secs = seconds.divmod(60)
		hours, minutes = minutes.divmod(60)
		hours_text = "%02d" % hours
		minutes_text = "%02d" % minutes
		"#{hours_text}:#{minutes_text}:00"
	end
	def zip_area_name(zipcode)
	  return nil unless (zipcode.class == String) 
	  return nil unless (zipcode.size == 5)
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
