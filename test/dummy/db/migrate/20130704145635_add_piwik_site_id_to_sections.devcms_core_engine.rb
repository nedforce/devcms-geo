# This migration comes from devcms_core_engine (originally 20130329111106)
class AddPiwikSiteIdToSections < ActiveRecord::Migration
  def change
    add_column :sections, :piwik_site_id, :string, references: nil
  end
end
