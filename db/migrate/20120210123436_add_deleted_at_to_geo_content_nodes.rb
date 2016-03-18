class AddDeletedAtToGeoContentNodes < ActiveRecord::Migration
  def up
    conn = ActiveRecord::Base.connection

    unless conn.columns(:geo_viewers).any? { |c| c.name == 'deleted_at' }
      add_column :geo_viewers, :deleted_at, :datetime

      add_index :geo_viewers, :deleted_at

      conn.execute("UPDATE geo_viewers SET deleted_at = nodes.deleted_at FROM nodes WHERE nodes.content_type = 'GeoViewer' AND nodes.content_id = geo_viewers.id AND nodes.deleted_at IS NOT NULL")
    end
  end

  def down
  end
end
