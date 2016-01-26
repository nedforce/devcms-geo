# This migration comes from devcms_core_engine (originally 20150817135049)
class AddContentBoxShowLinkToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :content_box_show_link, :boolean, nil: true, default: true
  end
end
