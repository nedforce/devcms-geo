class AddInheritImagesToGeoViewers < ActiveRecord::Migration
  def self.up
    add_column :geo_viewers, :inherit_images, :boolean
  end

  def self.down
    remove_column :geo_viewers, :inherit_images
  end
end
