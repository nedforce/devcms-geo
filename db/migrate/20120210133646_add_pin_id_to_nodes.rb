class AddPinIdToNodes < ActiveRecord::Migration
  def up
    add_column :nodes, :pin_id, :integer
  end

  def down
    remove_column :nodes, :pin_id
  end
end
