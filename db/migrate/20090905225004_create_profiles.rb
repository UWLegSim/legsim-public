class CreateProfiles < ActiveRecord::Migration[4.2]
  def self.up
    create_table :profiles do |t|
      t.integer :chamber_role_id
      t.text    :statement
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
