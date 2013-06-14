class NycMuseum < ActiveRecord::Base
  attr_accessible :address, :closing, :name, :phone, :rates, :specials

  def self.update_from_feed(feed_url = 'http://nycopendata.socrata.com/api/file_data/g5iiDl27zmKcETR-hHG58WnVB4ZKgnCUMwnK_dHW2AY?filename=NYCGO_museums%2520and%2520galleries_001.xml', 
  	main_elements='/museums/museum')

	require 'open-uri'
    
    xml_doc = REXML::Document.new open(feed_url)
    self.delete_all
	xml_doc.get_elements(main_elements).each do |main_element|  
		this_event = {}
		main_element.each_element_with_text do |element|
			this_event[element.name.to_sym] = element.cdatas.join(';')
		end
		# ele.each_element_with_text {|e| puts "#{e.name} => #{e.text}"}
		unless this_event.empty?
			self.create!(this_event)
		end
    end
  end

end
