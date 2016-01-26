# This migration comes from devcms_core_engine (originally 20150624112212)
class AddAuthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    add_index  :users, :auth_token
  end
end
