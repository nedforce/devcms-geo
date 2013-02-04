# This migration comes from devcms_core_engine (originally 20120725150707)
class RemoveDbBasedFileStorage < ActiveRecord::Migration
  def up
    unless Attachment.exists? :file => nil
      drop_table :db_files
      remove_column :attachments, :db_file_id
    else
      raise "Unconverted attachments found!"
    end

    unless Image.exists? :file => nil
      remove_column :images, :data
    else
      raise "Unconverted images found!"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
