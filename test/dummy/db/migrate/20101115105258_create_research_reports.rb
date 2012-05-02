class CreateResearchReports < ActiveRecord::Migration
  def self.up
    create_table :research_reports do |t|
      t.string  :title,       :null => false
      t.text    :preamble
      t.text    :description
      t.text    :conclusions
      t.date    :publication_date
      t.boolean :use_default_source
      t.text    :source
      t.string  :report_type

      t.timestamps
    end
  end

  def self.down
    drop_table :research_reports
  end
end
