class RemoveParentRelationsFromGovModels < ActiveRecord::Migration
  def self.up
    remove_column :permits, :permit_archive_id if Permit.column_names.include?('permit_archive_id')
    remove_column :legislations, :legislation_archive_id if Legislation.column_names.include?('legislation_archive_id')
  end

  def self.down
    add_column :permits, :permit_archive_id, :integer, :references => :permit_archives
    add_column :legislations, :legislation_archive_id, :integer, :references => :legislation_archives
  end
end
