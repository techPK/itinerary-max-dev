class CreateEventSelectors < ActiveRecord::Migration
  def change
    create_table :event_selectors do |t|

      t.timestamps
    end
  end
end
