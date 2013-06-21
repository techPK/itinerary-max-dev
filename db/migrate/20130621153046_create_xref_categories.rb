class CreateXrefCategories < ActiveRecord::Migration
  def change
    create_table :xref_categories do |t|
      t.string :category
      t.belongs_to :event
      t.datetime :event_start
      t.datetime :event_end
      t.integer :typical_visit_duration
      t.string :geo_location
      t.string :zipcode

      t.timestamps
    end
    add_index :xref_categories, :event_id
    add_index :xref_categories, :category
    add_index :xref_categories, [:category, :zipcode]
  end
end
