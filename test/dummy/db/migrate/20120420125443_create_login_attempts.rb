class CreateLoginAttempts < ActiveRecord::Migration
  def up
    create_table :login_attempts do |t|
      t.string  :ip,         :null => false
      t.string  :user_login
      t.boolean :success,    :null => false, :default => false
      t.timestamps
    end
  end

  def down
    drop_table :login_attempts
  end
end
