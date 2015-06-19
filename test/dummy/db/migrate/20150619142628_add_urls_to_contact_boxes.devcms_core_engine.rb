# This migration comes from devcms_core_engine (originally 20150311130328)
class AddUrlsToContactBoxes < ActiveRecord::Migration
  def change
    add_column :contact_boxes, :more_addresses_url, :string
    add_column :contact_boxes, :more_times_url,     :string
  end
end
