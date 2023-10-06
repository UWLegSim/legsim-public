class CreateChamberSettings < ActiveRecord::Migration[4.2]
  def self.up
    create_table :chamber_settings do |t|
      t.integer :chamber_id
      t.string  :name
      t.string  :value
      t.timestamps
    end
  end

  def self.down
    drop_table :chamber_settings
  end
end
