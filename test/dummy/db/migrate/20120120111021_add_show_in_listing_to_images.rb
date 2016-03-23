class AddShowInListingToImages < ActiveRecord::Migration
  
  class Image < ActiveRecord::Base
  end
  
  def up
    add_column :images, :show_in_listing, :boolean, :default => true, :null => false
    
    Image.reset_column_information
    
    Image.update_all 'show_in_listing = true'
  end

  def down
    remove_column :images, :show_in_listing
  end
end
