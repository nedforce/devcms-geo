# This migration comes from devcms_core_engine (originally 20120808142305)
class AddShortTitleToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :short_title, :string
  end
end
