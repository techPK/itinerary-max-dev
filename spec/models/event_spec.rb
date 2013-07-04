require 'spec_helper'

describe Event do
  pending "add some examples to (or delete) #{__FILE__}"
end

describe SeatGeekEvent do
  it "has correct columns" do 
  	expect(SeatGeekEvent.load_events(1)).to eq(1)
  	event =  SeatGeekEvent.first
  	expect(event.source_name).to eq(SeatGeekEvent.name)
  	expect(event.source_id.present?).to eq(true)
  	expect(event.appointed_start.present?).to eq(true)
  	# expect(event.appointed_stop.present?).to eq(true)
  	# expect(event.typical_visit_duration.present?).to eq(true)
  	expect(event.venue_id.present?).to eq(true)
  	expect(event.venue_name.present?).to eq(true)
  	expect(event.venue_address.present?).to eq(true)
  	expect(event.venue_postal_code.present?).to eq(true)
  	expect(event.venue_geolocation.present?).to eq(true)
  	expect(event.taxonomy.present?).to eq(true)
  	expect(event.more_info_url.present?).to eq(true)
  	expect(event.interest_level.present?).to eq(true)
  	expect(event.title.present?).to eq(true)
  	expect(event.more_info_url2.present?).to eq(true)
  end
end

describe NycParkEvent do
  it "has correct columns" do 
  	expect(NycParkEvent.load_events(1)).to eq(1)
  	event =  NycParkEvent.first
  	expect(event.source_name).to eq(NycParkEvent.name)
  	expect(event.source_id.present?).to eq(true)
  	expect(event.appointed_start.present?).to eq(true)
  	expect(event.appointed_stop.present?).to eq(true)
  	expect(event.typical_visit_duration.present?).to eq(true)
  	#expect(event.venue_id.present?).to eq(true)
  	expect(event.venue_name.present?).to eq(true)
  	expect(event.venue_address.present?).to eq(true)
  	#expect(event.venue_postal_code.present?).to eq(true)
  	expect(event.venue_geolocation.present?).to eq(true)
  	expect(event.taxonomy.present?).to eq(true)
  	expect(event.more_info_url.present?).to eq(true)
  	expect(event.interest_level.present?).to eq(true)
  	expect(event.title.present?).to eq(true)
  	#expect(event.more_info_url2.present?).to eq(true)
  end
end

