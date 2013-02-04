# This migration comes from devcms_core_engine (originally 20120817132521)
class AddRememberTokenIpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_token_ip, :string
  end
end
