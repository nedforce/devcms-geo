# This migration comes from devcms_core_engine (originally 20120921142701)
class AddLocaleToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :locale, :string
  end
end
