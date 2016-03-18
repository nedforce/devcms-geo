# This migration comes from devcms_core_engine (originally 20160316102156)
class RenameSettingsAltToLabel < ActiveRecord::Migration

  def change
    rename_column :settings, :alt, :label
  end

end
