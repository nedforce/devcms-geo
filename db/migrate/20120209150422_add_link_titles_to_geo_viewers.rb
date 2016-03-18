class AddLinkTitlesToGeoViewers < ActiveRecord::Migration
  def up
    add_column :geo_viewers, :link_titles, :boolean
  end

  def down
    remove_column :geo_viewers, :link_titles
  end
end
