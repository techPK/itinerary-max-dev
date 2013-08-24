class AddAveragePriceToEvent < ActiveRecord::Migration
  def change
    add_column :events, :tickets_available, :integer
    add_column :events, :lowest_price, :string
    add_column :events, :highest_price, :string
  end
end
