class ItineraryEventsController < ApplicationController
  # GET /itinerary_events
  # GET /itinerary_events.json
  def index
    @itinerary_events = ItineraryEvent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @itinerary_events }
    end
  end

  # GET /itinerary_events/1
  # GET /itinerary_events/1.json
  def show
    @itinerary_event = ItineraryEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @itinerary_event }
    end
  end

  # GET /itinerary_events/new
  # GET /itinerary_events/new.json
  def new
    @itinerary_event = ItineraryEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @itinerary_event }
    end
  end

  # GET /itinerary_events/1/edit
  def edit
    @itinerary_event = ItineraryEvent.find(params[:id])
  end

  # POST /itinerary_events
  # POST /itinerary_events.json
  def create
    @itinerary_event = ItineraryEvent.new(params[:itinerary_event])

    respond_to do |format|
      if @itinerary_event.save
        format.html { redirect_to @itinerary_event, notice: 'Itinerary event was successfully created.' }
        format.json { render json: @itinerary_event, status: :created, location: @itinerary_event }
      else
        format.html { render action: "new" }
        format.json { render json: @itinerary_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /itinerary_events/1
  # PUT /itinerary_events/1.json
  def update
    @itinerary_event = ItineraryEvent.find(params[:id])

    respond_to do |format|
      if @itinerary_event.update_attributes(params[:itinerary_event])
        format.html { redirect_to @itinerary_event, notice: 'Itinerary event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @itinerary_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /itinerary_events/1
  # DELETE /itinerary_events/1.json
  def destroy
    @itinerary_event = ItineraryEvent.find(params[:id])
    @itinerary_event.destroy

    respond_to do |format|
      format.html { redirect_to itinerary_events_url }
      format.json { head :no_content }
    end
  end
end
