# This migration comes from devcms_core_engine (originally 20130402151835)
class AddLastCheckedAtToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :last_checked_at, :datetime
  end
end
