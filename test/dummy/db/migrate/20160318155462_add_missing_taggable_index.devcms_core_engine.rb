# This migration comes from devcms_core_engine (originally 20160316110762)
# This migration comes from acts_as_taggable_on_engine (originally 4)
class AddMissingTaggableIndex < ActiveRecord::Migration
  def up
    add_index :taggings, [:taggable_id, :taggable_type, :context]
  end

  def down
    remove_index :taggings, [:taggable_id, :taggable_type, :context]
  end
end
