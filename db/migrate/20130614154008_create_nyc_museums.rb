class CreateNycMuseums < ActiveRecord::Migration
  def change
    create_table :nyc_museums do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :closing
      t.string :rates
      t.string :specials

      t.timestamps
    end
  end
end
