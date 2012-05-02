# This migration comes from devcms_core_engine (originally 20120502133234)
class AddSubscriptionEnabledToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :subscription_enabled, :boolean, :default => false
  end

  def self.down
    remove_column :events, :subscription_enabled
  end
end
