class CreateResearchThemes < ActiveRecord::Migration
  def self.up
    create_table :research_themes do |t|
      t.string :title, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :research_themes
  end
end
