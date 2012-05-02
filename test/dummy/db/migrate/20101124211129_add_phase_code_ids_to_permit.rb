class AddPhaseCodeIdsToPermit < ActiveRecord::Migration
  def self.up
    add_column :permits, :phase_code_id, :integer, :references => nil
  end

  def self.down
    remove_column :permits, :phase_code_id
  end
end
