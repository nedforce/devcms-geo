class CreatePins < ActiveRecord::Migration
  def up
    create_table :pins do |t|
      t.string :title
      t.string :file
    end
  end

  def down
    drop_table :pins
  end
end
