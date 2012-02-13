class AddLinkTitlesToGeoViewers < ActiveRecord::Migration
  def self.up
    add_column :geo_viewers, :link_titles, :boolean
  end

  def self.down
    remove_column :geo_viewers, :link_titles
  end
end
