class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    Event.update_all_events(5) unless Event.where(:appointed_start => DateTime.now.beginning_of_day..DateTime.now.end_of_day).present?
    
    puts "params='#{params.inspect}'"  # Testing only
    # Use Session Variable to determine state
    if session[:search].blank?
      @where = '' # NYC' # "Manhattan Bronx Brooklyn Queens Staten-Island"
      @when_day = '' #[any_day] today tomorrow beyond_tomorrow"
      @when_time = '' # "[any_time] morning afternoon evening night late-night early-morning"
      @admission = "[any] general frugal free senior student citypass nypass ny_explorer-pass go-select"
    end

    @where = params[:where] if params[:where].present?
    @when_day = params[:when_day] if params[:when_day]
    @when_time = params[:when_time] if params[:when_time]
    @specials = params[:admission] if params[:admission]

    if @selected_categories = params[:selected_categories]
       @select_categories = @selected_categories.keys
      @events = Event.where(taxonomy:@selected_categories.keys)
    else
      @events = []
      @selected_categories = nil
      @select_categories = 
        Event.where(
          :appointed_start => 
            DateTime.now.beginning_of_day..(DateTime.now + 2.days).end_of_day).uniq.pluck(:taxonomy)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

end
