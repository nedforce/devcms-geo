class CreateSharepointLists < ActiveRecord::Migration
  def self.up
    create_table "share_point_lists", :force => true do |t|
      t.string   "guid",              :null => false
      t.string   "last_change_token"
      t.integer  "node_id",           :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "paging_token"
      t.string   "site"
    end
    
    add_index :share_point_lists, :guid, :unique => true
    add_index :share_point_lists, :node_id
    
    add_column :nodes, :external_id, :string, :null=> true, :references => nil
    add_index :nodes, :external_id        
  end

  def self.down
    drop_table :share_point_lists
    remove_column :nodes, :external_id    
  end
end
