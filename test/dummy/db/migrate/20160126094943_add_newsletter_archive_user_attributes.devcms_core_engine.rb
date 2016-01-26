# This migration comes from devcms_core_engine (originally 20150819065406)
class AddNewsletterArchiveUserAttributes < ActiveRecord::Migration
  def change
    add_column :newsletter_archives_users, :id, :primary_key
    add_column :newsletter_archives_users, :created_at, :datetime
    add_column :newsletter_archives_users, :updated_at, :datetime
  end
end
