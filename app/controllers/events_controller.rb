class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    Event.update_all_events(5) unless Event.where(:appointed_start => DateTime.now.beginning_of_day..DateTime.now.end_of_day).present?
    
    puts "params='#{params.inspect}'"  # Testing only

    @where = (params[:where] || session[:where]) || ''
    @when_day = (params[:when_day] || session[:when_day]) || ''
    @when_time = (params[:when_time] || session[:when_time]) || ''
    @admission = (params[:admission] || session[:admission]) || ''

    if @selected_categories = params[:selected_categories]
      @select_categories = @selected_categories.keys
      if event_selector = EventSelector.find_by_id(session[:event_selector_id])
        EventCategory.delete_all(event_selector_id:event_selector.id) 
        @select_categories.each do |select_category|
          event_selector.event_categories << EventCategory.new(category:select_category)
        end
        event_selector.save
      end
      @events = Event.where(taxonomy:@selected_categories.keys)
      case @where.downcase
      when 'manhattan'
        @events = @events.manhattan
      when 'bronx'
        @events = @events.bronx
      when 'brooklyn'
        @events = @events.brooklyn
      when 'queens'
        @events = @events.queens
      when 'staten_island'
        @events = @events.staten_island
      end        
    else
      @events = []
      event_selector = EventSelector.new(times_accessed:0)
      session[:event_selector_id] = event_selector.id     
      # @selected_categories = nil
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
