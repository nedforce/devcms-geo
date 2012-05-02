class AddPaperIndexToPermitPhaseProductDescriptions < ActiveRecord::Migration
  def self.up
    add_column :permit_phase_product_descriptions, :paper_index, :string
  end

  def self.down
    remove_column :permit_phase_product_descriptions, :paper_index
  end
end
