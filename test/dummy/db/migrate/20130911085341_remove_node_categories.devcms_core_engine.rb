# This migration comes from devcms_core_engine (originally 20130911082407)
class RemoveNodeCategories < ActiveRecord::Migration
  def change
    drop_table :node_categories, :categories
  end
end
