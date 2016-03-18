class AddCombinedViewerToGeoViewers < ActiveRecord::Migration
  def up
    add_column :geo_viewers, :combined_viewer, :boolean
  end

  def down
    remove_column :geo_viewers, :combined_viewer
  end
end
