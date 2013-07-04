class AddMoreInfoUrl2ToEvents < ActiveRecord::Migration
  def change
    add_column :events, :more_info_url2, :string
  end
end
