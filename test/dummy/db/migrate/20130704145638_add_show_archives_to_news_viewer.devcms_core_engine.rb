# This migration comes from devcms_core_engine (originally 20130611100167)
class AddShowArchivesToNewsViewer < ActiveRecord::Migration
  def up
    add_column :news_viewers, :show_archives, :boolean, default: true
  end
  def down
    remove_column :news_viewers, :show_archives
  end
end
