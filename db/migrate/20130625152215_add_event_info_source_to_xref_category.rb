class AddEventInfoSourceToXrefCategory < ActiveRecord::Migration
  def change
    add_column :xref_categories, :event_info_source, :string
  end
end
