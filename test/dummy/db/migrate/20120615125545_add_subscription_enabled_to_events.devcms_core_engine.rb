# This migration comes from devcms_core_engine (originally 20120502133234)
class AddSubscriptionEnabledToEvents < ActiveRecord::Migration
  def up
    add_column :events, :subscription_enabled, :boolean, :default => false
  end

  def down
    remove_column :events, :subscription_enabled
  end
end
