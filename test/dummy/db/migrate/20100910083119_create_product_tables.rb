class CreateProductTables < ActiveRecord::Migration
  def self.up
    create_table :product_catalogues do |t|
      t.string   "title",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "description"
    end

    add_index "product_catalogues", "created_at"
    add_index "product_catalogues", "updated_at"

    create_table :product_social_situations do |t|
      t.string   "situation",  :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "product_social_situations", "created_at"
    add_index "product_social_situations", "situation", :unique => true
    add_index "product_social_situations", "updated_at"

    create_table :product_themes do |t|
      t.string   "theme",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "external_id", :references => nil
      t.integer  "parent_id"
      t.text     "keywords"
      t.text     "description"
    end

    add_index "product_themes", "created_at"
    add_index "product_themes", ["parent_id", "theme"], :unique => true
    add_index "product_themes", "updated_at"
    
    create_table :products do |t|
      t.string   "title",                       :null => false
      t.integer  "product_theme_id"
      t.integer  "product_social_situation_id"
      t.text     "description"
      t.text     "delivery"
      t.text     "bring_along"
      t.text     "cost"
      t.text     "result"
      t.text     "legislation"
      t.text     "more_info"
      t.text     "forms"
      t.integer  "hits"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "extra"
      t.text     "summary"
      t.text     "conditions"
      t.text     "process"
      t.text     "background"
      t.text     "tips"
      t.text     "local_legislation"
      t.text     "authority"
      t.text     "actor"
      t.text     "references"
      t.text     "contacts"
      t.datetime "last_changed"
      t.string   "external_id", :references => nil
      t.text     "external_url"
    end

    add_index "products", "created_at"
    add_index "products", "hits"
    add_index "products", "product_social_situation_id"
    add_index "products", "product_theme_id"
    add_index "products", "title"
    add_index "products", "updated_at"      
    
    create_table :product_synonyms do |t|
      t.integer  "product_id"
      t.string   "synonym",    :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "product_synonyms", "created_at"
    add_index "product_synonyms", "product_id"
    add_index "product_synonyms", "updated_at"    
    
    create_table :product_categories do |t|
      t.string   "title",       :null => false
      t.text     "keywords"
      t.text     "description"
      t.string   "external_id", :null => false, :references => nil
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "ancestry"
    end

    add_index "product_categories", "ancestry"
    add_index "product_categories", "external_id", :unique => true

    create_table "product_categories_products", :force => true do |t|
      t.integer  "product_id"
      t.integer  "product_category_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end    
  end

  def self.down
    drop_table :product_categories_products
    drop_table :product_categories
    drop_table :product_synonyms
    drop_table :products
    drop_table :product_themes   
    drop_table :product_social_situations 
    drop_table :product_catalogues
  end
end
