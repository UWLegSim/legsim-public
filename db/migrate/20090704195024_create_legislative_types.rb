class CreateLegislativeTypes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :legislative_types do |t|
      t.string  :name
      t.string  :abbr
      t.integer :chamber_id
      t.timestamps
    end
  end

  def self.down
    drop_table :legislative_types
  end
end
