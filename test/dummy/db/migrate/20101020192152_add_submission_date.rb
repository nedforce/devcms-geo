class AddSubmissionDate < ActiveRecord::Migration
  def self.up
    add_column :permits, :submission_date, :date
  end

  def self.down
    remove_columns :permits, :submission_date
  end
end
