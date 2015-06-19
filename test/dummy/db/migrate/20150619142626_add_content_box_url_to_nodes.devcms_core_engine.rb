# This migration comes from devcms_core_engine (originally 20141215093321)
class AddContentBoxUrlToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :content_box_url, :string
  end
end
