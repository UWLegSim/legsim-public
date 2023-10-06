class CreateAmendments < ActiveRecord::Migration[4.2]
  def self.up
    create_table :amendments do |t|
      t.integer :referral_id
      t.integer :chamber_role_id
      t.text    :text
      t.timestamps
    end
  end

  def self.down
    drop_table :amendments
  end
end
