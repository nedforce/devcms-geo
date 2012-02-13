class AddPinIdToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :pin_id, :integer
  end

  def self.down
    remove_column :nodes, :pin_id
  end
end
