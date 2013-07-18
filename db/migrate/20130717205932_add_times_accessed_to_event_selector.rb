class AddTimesAccessedToEventSelector < ActiveRecord::Migration
  def change
    add_column :event_selectors, :times_accessed, :integer
  end
end
