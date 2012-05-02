class CreateResearchArchives < ActiveRecord::Migration
  def self.up
    create_table :research_archives do |t|
      t.string :title,          :null => false
      t.text   :description
      t.text   :default_source

      t.timestamps
    end
  end

  def self.down
    drop_table :research_archives
  end
end
