class CreatePins < ActiveRecord::Migration
  def self.up
    create_table :pins do |t|
      t.string :title
      t.string :file
    end
  end

  def self.down
    drop_table :pins
  end
end
