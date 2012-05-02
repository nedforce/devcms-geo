class CreatePermitTables < ActiveRecord::Migration
  def self.up
    create_table :permit_archives do |t|
      t.string   "title",                              :null => false
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "publication_node_id", :references => nil
      t.integer  "publication_number"
      t.text     "publication_notification_addresses"
    end

    create_table :permit_phases do |t|
      t.string   "name"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table :permit_viewers do |t|
      t.string   "title",              :null => false
      t.text     "description"
      t.string   "product_types"
      t.string   "phases"
      t.string   "period_types"
      t.string   "zip_codes"
      t.string   "population_centers"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table :permits do |t|
      t.string   "title",               :null => false
      t.text     "description",         :null => false
      t.string   "product_type",        :null => false
      t.string   "company_number"
      t.string   "company_name"
      t.string   "company_address"
      t.string   "period_type"
      t.datetime "period_start_date"
      t.datetime "period_end_date"
      t.string   "reference"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "phase_id", :references => :permit_phases
      t.string   "population_center"
      t.string   "announcement_number"
      t.string   "reference_number"
      t.date     "published_at"
    end

    add_index "permits", "announcement_number"
    add_index "permits", "population_center"
    add_index "permits", "published_at"
    add_index "permits", "reference_number"

    create_table :permit_activities do |t|
      t.integer  "permit_id",  :null => false
      t.string   "name",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table :permit_addresses do |t|
      t.integer  "permit_id",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "postal_code"
      t.string   "house_number"
      t.string   "house_character"
      t.string   "complement"
    end
        
    create_table :permit_coordinates do |t|
      t.integer "permit_id", :null => false
      t.float   "x",         :null => false
      t.float   "y",         :null => false
      t.float   "z"
    end

    create_table :permit_parcels do |t|
      t.integer  "permit_id",  :null => false
      t.string   "section",    :null => false
      t.string   "number",     :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end    
  end

  def self.down
    drop_table :permit_addresses
    drop_table :permit_activities
    drop_table :permit_coordinates
    drop_table :permit_parcels  
    drop_table :permits
    drop_table :permit_viewers
    drop_table :permit_phases
    drop_table :permit_archives
  end
end
