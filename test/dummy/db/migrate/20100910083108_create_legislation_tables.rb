class CreateLegislationTables < ActiveRecord::Migration
  def self.up
    create_table :legislation_archives do |t|
      t.string   "title",          :null => false
      t.text     "description"
      t.date     "last_import_on"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table :legislations do |t|
      t.string   "identifier",  :null => false
      t.string   "title",       :null => false
      t.text     "body"
      t.date     "issued_at"
      t.date     "modified_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "subject"
      t.string   "cite_title"
    end

    add_index "legislations", "identifier"
  end

  def self.down
    drop_table :legislations
    drop_table :legislation_archives
  end
end
