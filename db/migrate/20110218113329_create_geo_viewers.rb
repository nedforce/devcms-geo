class CreateGeoViewers < ActiveRecord::Migration
  def self.up
    create_table :geo_viewers do |t|
      t.string  :title, :null => false
      t.text    :description
      t.text    :filter_settings
      t.text    :map_settings
      
      t.timestamps
    end
  end

  def self.down
    drop_table :geo_viewers
  end
end
