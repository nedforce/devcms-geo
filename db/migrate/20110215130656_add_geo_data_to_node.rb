class AddGeoDataToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :lat, :float
    add_column :nodes, :lng, :float
    add_column :nodes, :location, :string, :length => 1024
    add_index :nodes, [:lat, :lng]
    
    rename_column :events, :location, :location_description
    
    Node.reset_column_information
    
    Permit.all do |permit|
      permit.node.update_attribute :location, permit.addresses.first.to_s
    end
  end

  def self.down
    remove_column :nodes, :lat
    remove_column :nodes, :lng
    remove_column :nodes, :location
    
    rename_column :events, :location_description, :location
  end
end
