class AddUrlToEvent < ActiveRecord::Migration
  def up
    add_column :events, :url, :string
    add_column :events, :venue_url, :string
    remove_column :events, :more_info_url
    remove_column :events, :more_info_url2
  end
  def down
    remove_column :events, :url
    remove_column :events, :venue_url
    add_column :events, :more_info_url, :string
    add_column :events, :more_info_url2, :string
  end
end
