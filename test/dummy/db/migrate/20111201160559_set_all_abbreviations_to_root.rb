class SetAllAbbreviationsToRoot < ActiveRecord::Migration
  def self.up
    unless Node.count.zero?
      Abbreviation.update_all :node_id => Node.root.id
    end
  end

  def self.down
  end
end
