class AddInheritPinsToGeoViewers < ActiveRecord::Migration
  def up
    add_column :geo_viewers, :inherit_pins, :boolean
  end

  def down
    remove_column :geo_viewers, :inherit_pins
  end
end
