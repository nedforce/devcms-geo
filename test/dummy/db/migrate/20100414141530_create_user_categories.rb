class CreateUserCategories < ActiveRecord::Migration
  def up
    create_table :user_categories do |t|
      t.references :user, :null => false
      t.references :category, :null => false

      t.timestamps
    end

    add_index :user_categories, [ :user_id, :category_id ], :unique => true
  end

  def down
    drop_table :user_categories
  end
end
