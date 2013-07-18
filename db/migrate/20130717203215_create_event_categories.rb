class CreateEventCategories < ActiveRecord::Migration
  def change
    create_table :event_categories do |t|
      t.belongs_to :event_selector
      t.string :category

      t.timestamps
    end
    add_index :event_categories, :event_selector_id
  end
end
