class CreatePermitPhaseProductDescriptions < ActiveRecord::Migration

  class PermitPhase < ActiveRecord::Base
    has_many :permits, :foreign_key => 'phase_id'
  end

  def self.up
    create_table :permit_phase_product_descriptions do |t|
      t.integer :product_type_id, :references => nil, :null => true
      t.integer :phase_id,        :references => nil, :null => false
      t.text :description

      t.timestamps
    end

    add_column :permits, :product_type_id, :integer, :references => nil
    remove_foreign_key :permits, 'permits_phase_id_fkey'

    Permit.reset_column_information

    # Migrate phases
    mapping = {}
    PermitPhase.all.each { |phase| mapping[phase.name] = phase.permits.map &:id }

    mapping.each do |phase, ids|
      Permit.update_all("phase_id = #{Permit::PHASES.index(phase)}", "#{Permit.quoted_table_name}.id IN (#{ids.join(',')})") unless ids.empty?
    end

    raise "Failed to migrate phases" unless mapping.all? do |phase, ids|
      ids.empty? || ids.size == Permit.count(:conditions => { :id => ids, :phase_id => Permit::PHASES.index(phase) })
    end

    # Migrate products
    Permit::PRODUCT_TYPES.each_with_index do |product, index|
      Permit.update_all("product_type_id = #{index}", "#{Permit.quoted_table_name}.product_type = '#{product}'")
    end

    remove_column :permits, :product_type

    PermitPhaseProductDescription.reset_column_information

    # Create phase product descriptions
    PermitPhase.all.each do |phase|
      PermitPhaseProductDescription.create!(:description => phase.description, :phase => phase.name)
    end

    drop_table :permit_phases

  end

  def self.down
    drop_table :permit_phase_product_descriptions
  end
end
