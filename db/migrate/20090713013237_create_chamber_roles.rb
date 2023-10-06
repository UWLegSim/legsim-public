class CreateChamberRoles < ActiveRecord::Migration[4.2]
  def self.up
    create_table :chamber_roles do |t|
      t.integer :chamber_id
      t.integer :user_id
      t.string  :type
      t.timestamps
    end
  end

  def self.down
    drop_table :chamber_roles
  end
end
