class AddExtendedProductTypeToPermits < ActiveRecord::Migration
  def self.up
    add_column :permits, :product_type_code_id, :integer, :references => nil
  end

  def self.down
    remove_column :permits, :product_type_code_id
  end
end
