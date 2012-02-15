class AddCombinedViewerToGeoViewers < ActiveRecord::Migration
  def self.up
    add_column :geo_viewers, :combined_viewer, :boolean
  end

  def self.down
    remove_column :geo_viewers, :combined_viewer
  end
end
