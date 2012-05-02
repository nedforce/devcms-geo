class CreateOpusPlusImporters < ActiveRecord::Migration
  def self.up
    create_table :opus_plus_importers do |t|
      t.integer  "product_catalogue_id"
      t.string   "kid",                  :null => false
      t.string   "lid",                  :default => "4a88d168-ef2e-4b7e-a992-cd5c513c19f6"
      t.datetime "created_at"
      t.datetime "updated_at"
    end      
  end

  def self.down
    drop_table :opus_plus_importers
  end
end
