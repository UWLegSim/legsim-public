class CreateFilibusters < ActiveRecord::Migration[4.2]
  def self.up
    create_table :filibusters do |t|
      t.integer :motion_id
      t.integer :chamber_role_id
      t.timestamps
    end
  end

  def self.down
    drop_table :filibusters
  end
end
