# This migration comes from devcms_core_engine (originally 20130329114327)
class AddTransationTimeToCarrousels < ActiveRecord::Migration
  def change
    add_column :carrousels, :transition_time, :integer
    rename_column :carrousels, :display_time_in_seconds, :display_time
  end
end
