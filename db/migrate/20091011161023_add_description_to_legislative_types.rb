class AddDescriptionToLegislativeTypes < ActiveRecord::Migration[4.2]
  def self.up
    add_column :legislative_types, :description, :string
  end

  def self.down
    drop_column :legislative_types, :description
  end
end
