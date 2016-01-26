# This migration comes from devcms_core_engine (originally 20150817055428)
class AddArchivedToNewsArchive < ActiveRecord::Migration
  def change
    add_column :news_archives, :archived, :boolean, default: false, nil: false
  end
end
