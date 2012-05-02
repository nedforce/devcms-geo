class AddDeletedAtToGovContentNodes < ActiveRecord::Migration
  def self.up
    conn = ActiveRecord::Base.connection
    
    %w( legislation_archives legislations product_catalogues products permit_archives permit_viewers permits ).each do |table_name|
      unless conn.columns(table_name).any? { |c| c.name == 'deleted_at' }
        add_column table_name, :deleted_at, :datetime
    
        add_index table_name, :deleted_at
      
        conn.execute("UPDATE #{table_name} SET deleted_at = nodes.deleted_at FROM nodes WHERE nodes.content_type = '#{table_name.classify}' AND nodes.content_id = #{table_name}.id AND nodes.deleted_at IS NOT NULL")
      end
    end
  end

  def self.down
  end
end
