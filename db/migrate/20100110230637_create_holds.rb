class CreateHolds < ActiveRecord::Migration[4.2]
  def self.up
    create_table :holds do |t|
      t.integer :referral_id
      t.integer :chamber_role_id
      t.timestamps
    end
  end

  def self.down
    drop_table :holds
  end
end
