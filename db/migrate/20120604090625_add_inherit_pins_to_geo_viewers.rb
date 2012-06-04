class AddInheritPinsToGeoViewers < ActiveRecord::Migration
  def self.up
    add_column :geo_viewers, :inherit_pins, :boolean
  end

  def self.down
    remove_column :geo_viewers, :inherit_pins
  end
end
