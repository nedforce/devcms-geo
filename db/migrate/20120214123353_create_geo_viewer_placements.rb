class CreateGeoViewerPlacements < ActiveRecord::Migration
  def up
    create_table :geo_viewer_placements do |t|
      t.integer :combined_geo_viewer_id, :references => :geo_viewers
      t.integer :geo_viewer_id
      t.boolean :is_toggable
      t.boolean :is_toggled, :default => true
      t.timestamps
    end

    add_index :geo_viewer_placements, :combined_geo_viewer_id
    add_index :geo_viewer_placements, :geo_viewer_id
  end

  def down
    drop_table :geo_viewer_placements
  end
end
