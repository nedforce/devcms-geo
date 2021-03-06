class AddGeoDataToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :lat, :float
    add_column :nodes, :lng, :float
    add_column :nodes, :location, :string, :length => 1024
    add_index :nodes, [:lat, :lng]

    say 'Resetting the column information on node'
    Node.reset_column_information

    if defined?(Permit)
      say_with_time 'Adding location information to all permits' do
        Permit.all do |permit|
          permit.node.update_attribute :location, permit.addresses.first.to_s
        end
      end
    end
  end

  def self.down
    remove_column :nodes, :lat
    remove_column :nodes, :lng
    remove_column :nodes, :location
  end
end
