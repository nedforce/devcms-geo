# This migration comes from devcms_core_engine (originally 20160620081055)
class AddRenewedPasswordAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :renewed_password_at, :datetime
    User.update_all renewed_password_at: Time.now
  end
end
