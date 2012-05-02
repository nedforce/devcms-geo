class AddDateSentToPermits < ActiveRecord::Migration
  def self.up
    add_column :permits, :sent_at, :date
  end

  def self.down
    remove_column :permits, :sent_at
  end
end
