class CreateNycParkEvents < ActiveRecord::Migration
  def change
    create_table :nyc_park_events do |t|
      t.string :title
      t.string :guid
      t.string :link
      t.text :description
      t.datetime :published_at

      t.timestamps
    end
  end
end
