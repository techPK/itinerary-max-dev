class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    Event.update_all_events(25) unless Event.where(:appointed_start => DateTime.now.beginning_of_day..DateTime.now.end_of_day).present?

    @where = (params[:where] || session[:where]) || ''
    @when_day = (params[:when_day] || session[:when_day]) || ''
    @when_time = (params[:when_time] || session[:when_time]) || ''
    @admission = (params[:admission] || session[:admission]) || ''

    if @selected_categories = params[:selected_categories]
      @select_categories = @selected_categories.keys

      unless session[:event_selector_id]
        event_selector = EventSelector.create(times_accessed:0)
        session[:event_selector_id] = event_selector.id
        puts "=== session[session[:event_selector_id] = #{session[:event_selector_id]} ============$$$$#{session[:event_selector_id]}"     
      end

      if event_selector = EventSelector.find_by_id(session[:event_selector_id])
        EventCategory.delete_all(event_selector_id:event_selector.id) 
        @select_categories.each do |select_category|
          event_selector.event_categories << EventCategory.new(category:select_category)
        end
        event_selector.times_accessed += 1
        event_selector.save
        puts "=== event_selector.times_accessed = #{event_selector.times_accessed} ============$$$$#{session[:event_selector_id]}"
        puts "=== event_selector.event_categories.count = #{event_selector.event_categories.count} ============$$$$#{session[:event_selector_id]}"

      end
      
      @events = Event.where(taxonomy:@selected_categories.keys)

      case @when_day.downcase
      when 'today'
        @events = @events.today
      when 'tomorrow'
        @events = @events.tomorrow
      when 'beyond_tomorrow'
        @events = @events.beyond_tomorrow
      end        

      case @when_time.downcase
      when 'early_morning'
        @events = @events.early_morning
      when 'morning'
        @events = @events.morning
      when 'afternoon'
        @events = @events.afternoon
      when 'evening'
        @events = @events.evening
      when 'night'
        @events = @events.night
      when 'late_night'
        @events = @events.late_night
      end        

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
      if session[:event_selector_id]
        event_selector = EventSelector.find_by_id(session[:event_selector_id])
        EventCategory.delete_all(event_selector_id:event_selector.id) 
      end
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
