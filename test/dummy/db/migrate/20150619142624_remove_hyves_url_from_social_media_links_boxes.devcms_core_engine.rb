# This migration comes from devcms_core_engine (originally 20140724145050)
class RemoveHyvesUrlFromSocialMediaLinksBoxes < ActiveRecord::Migration
  def up
    remove_column :social_media_links_boxes, :hyves_url
  end

  def down
    add_column :social_media_links_boxes, :hyves_url, :string
  end
end
