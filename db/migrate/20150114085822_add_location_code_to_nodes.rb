class AddLocationCodeToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :location_code, :string
  end
end
