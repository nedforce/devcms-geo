class AddInheritImagesToGeoViewers < ActiveRecord::Migration
  def up
    add_column :geo_viewers, :inherit_images, :boolean
  end

  def down
    remove_column :geo_viewers, :inherit_images
  end
end
