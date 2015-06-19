# This migration comes from devcms_core_engine (originally 20150311090205)
class AddOptionsToDisableLinksInContactBoxes < ActiveRecord::Migration
  def change
    add_column :contact_boxes, :show_more_addresses_link, :boolean, default: true
    add_column :contact_boxes, :show_more_times_link,     :boolean, default: true
  end
end
